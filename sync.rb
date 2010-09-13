require 'rubygems'
require "bundler/setup"
require 'teambox-client'
require 'things'
require 'time'
require 'timeout'
require File.join(File.dirname(__FILE__), 'lib', 'config_store')
require File.join(File.dirname(__FILE__), 'lib', 'task_list_cache')
require File.join(File.dirname(__FILE__), 'lib', 'helper')

config = ConfigStore.new("#{ENV['HOME']}/.teambox")
config['site_url'] ||= "http://teambox.com/"
config['output_info'] ||= true
config['timeout_limit'] ||= 40
    
Timeout::timeout(config['timeout_limit']) {
  httpauth = Teambox::HTTPAuth.new(config['username'], config['password'])
  client = Teambox::Base.new(httpauth)

  client.projects.each do |project|
    task_list_cache = TaskListCache.new(client, project.name)
    project_people = client.project(project.name).people
    person_id = Helper.find_person_id(project_people, client.account.id)
    unless person_id.nil?
      # update tasks marked as done in Things
      client.tasks.each do |task|
        things_todo = Things::Todo.find(task.name)
        if !things_todo.nil? && things_todo.completed? && Helper.is_task_open?(task.status)
          # API isn't great right now so we update task as resolved and add new comment to it
          client.update_project_task(project.name, task.id, {:status => 3})
          client.create_project_task_comment(project.name, task.id, {:status => 3, :body => "Sent from my Things.app"})
          puts "#{task.name} at remote set as done" if config['output_info']
        end
      end

      # fetch data from remote server
      client.tasks.each do |task|
        # grab only tasks assigned to current user
        if task.assigned_id == person_id
          things_todo = Helper.find_or_create_todo_in_things(task.name)
          # update only those that aren't completed in both local and remote
          unless !Helper.is_task_open?(task.status) && things_todo.completed? 
            notes = "Don't edit this field!\n" + 
              Helper.task_url(config, project.name, task.task_list_id, task.id)
            things_todo.project = Helper.find_or_create_project_in_things(project.name)
            things_todo.notes = notes
            unless task.due_on.nil?
              things_todo.due_date = Time.parse(task.due_on)
            end
            unless [0,1].include?(task.status)
              things_todo.complete
            else
              things_todo.open
            end
            things_todo.tag_names = task_list_cache[task.task_list_id]
            things_todo.save
            puts "\"#{task.name}\" have been saved in Things.app" if config['output_info']
          end
        end
      end

      # maybe add task from things to teambox app (in future)
      # things_project_tasks = things_project.todos
      # things_project_tasks.each do |todo|
      #   if !all_tasks.any?{|t| t.name == todo.name}
      #   end
      # end
    end
  end
}

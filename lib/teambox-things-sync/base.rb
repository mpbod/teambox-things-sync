module TeamboxThingsSync
  class Base
    
    attr_reader :config

    def initialize
      parse_config_file
      httpauth = Teambox::HTTPAuth.new(@config['username'], @config['password'],
                                       :api_endpoint => api_url(@config['teambox_url']))
      @client = Teambox::Base.new(httpauth)
    end

    def synchronise
      Timeout::timeout(@config['timeout_limit']) {
        begin
          projects = @client.projects
        rescue
          abort "Cannot fetch project list, check your internet connection."
        end
    
        projects.each do |project|
          log "Started working with #{project.name}"
          begin
            mark_as_done_at_remote(project)

            person_id = find_person_id(project.permalink)
            fetch_tasks_from_remote(project, person_id)
          rescue
            abort "Something went wrong while updating.\n" + $!
          end
        end
      }
    end


    def self.find_or_create_project_in_things(project_name)
      Things::Project.find(project_name) or Things::Project.create(:name => project_name)
    end

    def self.find_or_create_todo_in_things(todo_name)
      Things::Todo.find(todo_name) or Things::Todo.create(:name => todo_name)
    end

    def task_url(project_permalink, task_list_id, task_id)
      "#{@config['teambox_url']}/projects/#{project_permalink}/"+
        "task_lists/#{task_list_id}/tasks/#{task_id}"
    end

    def api_url(url)
      url.gsub("http://", "")
    end

    def is_task_open?(status)
      [0,1].include? status
    end

    private

      # update tasks marked as done in Things
      def mark_as_done_at_remote(project)
        @client.tasks.each do |task|
          things_todo = Things::Todo.find(task.name)
          
          #TODO: clean it up
          if !things_todo.nil? && things_todo.completed? && is_task_open?(task.status) &&
            !Things::App.lists.trash.reference.todos.name.get.include?(things_todo.name)
            # API isn't great right now, so we update task as resolved 
            # and add the new comment to it
            @client.update_project_task(project.permalink, task.id, {:status => 3})
            @client.create_project_task_comment(project.permalink, task.id,
                                                {:status => 3,
                                                 :body => "Sent from my Things.app"})
            log "#{task.name} at remote set as done"
          end
        end
      end

      # fetches current task data from remote
      def fetch_tasks_from_remote(project, person_id)
        task_list_cache = Cache::TaskListCache.new(@client, 
          {:project_permalink => project.permalink})
        @user_name_cache = Cache::UserNameCache.new(@client)
        @client.tasks.each do |task|
          # grab only tasks assigned to current user
          if task.assigned_id == person_id
            things_todo = Base.find_or_create_todo_in_things(task.name)
            # update only those that aren't completed in both local and remote
            if is_task_open?(task.status) || !things_todo.completed?
              things_todo.project = Base.find_or_create_project_in_things(project.name)
              things_todo.notes = build_notes(project.permalink, 
                task.task_list_id, task.id)
              things_todo.tag_names = task_list_cache[task.task_list_id]
              
              unless task.due_on.nil?
                things_todo.due_date = Time.parse(task.due_on)
              end

              # data from remote has higher priority
              unless is_task_open?(task.status)
                things_todo.complete
              else
                things_todo.open
              end
              
              things_todo.save              
              log "\"#{task.name}\" has been saved in Things.app"
            end
          end
        end
      end

      def upload_tasks_to_remote(project)
        # maybe add task from things to teambox app (in future)
        # things_project_tasks = things_project.todos
        # things_project_tasks.each do |todo|
        #   if !all_tasks.any?{|t| t.name == todo.name}
        #   end
        # end
      end

      def build_notes(project_permalink, task_list_id, task_id)
        notes = task_url(project_permalink, task_list_id, task_id)+"\n\n"
        @client.project_task_comments(project_permalink, task_id).reverse.each do |c|
          unless c.body.nil?
            notes << c.body + "\n----------\n\n"
          end
        end
        notes
      end
        
      # finds person_id in given project
      def find_person_id(project_permalink)
        project_people = @client.project_people(project_permalink)
        project_people.find { |person| person.user_id == @client.account.id }.id
      end

      def log(text)
        puts text if @config['output_log']
      end

    
      def parse_config_file
        @config = ConfigStore.new("#{ENV['HOME']}/.teambox")
        @config['teambox_url'] ||= "http://teambox.com"
        @config['output_log'] ||= true
        @config['timeout_limit'] ||= 40
        check_correctness_of_config
      end
    
      def check_correctness_of_config
        if @config['username'].nil? || @config['password'].nil?
          abort "'username' and/or 'password' not found in " +
            "#{ENV['HOME']}/.teambox file. See README."
        end
      
        unless @config['timeout_limit'].integer?
          abort "timeout_limit should be a number (integer)"
        end
      end
  end
end

module Helper
  def self.find_or_create_project_in_things(project_name)
    Things::Project.find(project_name) or Things::Project.create(:name => project_name)
  end

  def self.find_or_create_todo_in_things(todo_name)
    Things::Todo.find(todo_name) or Things::Todo.create(:name => todo_name)
  end

  def self.task_url(config, project_name, task_list_id, task_id)
    "#{config['site_url']}projects/#{project_name}/task_lists/#{task_list_id}/tasks/#{task_id}"
  end

  def self.find_person_id(project_people, account_id)
    person = project_people.find {|person| person.user_id == account_id}.id
  end
  
  def self.is_task_open?(status)
    [0,1].include? status
  end
end

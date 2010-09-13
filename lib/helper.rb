def find_or_create_project_in_things(project_name)
  Things::Project.find(project_name) or Things::Project.create(:name => project_name)
end

def find_or_create_todo_in_things(todo_name)
  Things::Todo.find(todo_name) or Things::Todo.create(:name => todo_name)
end

def task_url(config, project_name, task_list_id, task_id)
  "#{config['site_url']}projects/#{project_name}/task_lists/#{task_list_id}/tasks/#{task_id}"
end

def find_person_id(project_people, account_id)
  person_id = nil
  project_people.each do |pp|
    if pp.user_id == account_id
      person_id = pp.id
    end
  end
  person_id
end
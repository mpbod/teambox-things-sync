class TeamboxThingsSync
  # attr_writer :client

  def initialize(config)
    @config = config
    httpauth = Teambox::HTTPAuth.new(config['username'], config['password'],
                                     :api_endpoint => api_url(config['teambox_url']))
    @client = Teambox::Base.new(httpauth)
  end

  def synchronise
    begin
      projects = @client.projects
    rescue
      log "Cannot fetch project list, check your internet connection."
      exit
    end
    
    projects.each do |project|
      log "Started working with #{project.name}"
      begin
        mark_as_done_at_remote(project)

        person_id = find_person_id(project.permalink)
        fetch_tasks_from_remote(project, person_id)
      rescue
        log "Something went wrong"
      end
    end
  end


  def self.find_or_create_project_in_things(project_name)
    Things::Project.find(project_name) or Things::Project.create(:name => project_name)
  end

  def self.find_or_create_todo_in_things(todo_name)
    Things::Todo.find(todo_name) or Things::Todo.create(:name => todo_name)
  end

  def task_url(project_permalink, task_list_id, task_id)
    "#{@config['teambox_url']}/projects/#{project_permalink}/task_lists/#{task_list_id}/tasks/#{task_id}"
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
        if !things_todo.nil? && things_todo.completed? && is_task_open?(task.status)
          # API isn't great right now, so we update task as resolved and add new comment to it
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
      task_list_cache = TaskListCache.new(@client, project.permalink)
      @client.tasks.each do |task|
        # grab only tasks assigned to current user
        if task.assigned_id == person_id
          things_todo = TeamboxThingsSync.find_or_create_todo_in_things(task.name)
          # update only those that aren't completed in both local and remote
          if is_task_open?(task.status) || !things_todo.completed?
            things_todo.project = TeamboxThingsSync.find_or_create_project_in_things(project.name)
            things_todo.notes = "Don't edit this field!\n" +
              task_url(project.permalink, task.task_list_id, task.id)

            unless task.due_on.nil?
              things_todo.due_date = Time.parse(task.due_on)
            end

            # data from remote has higher priority
            unless is_task_open?(task.status)
              things_todo.complete
            else
              things_todo.open
            end

            things_todo.tag_names = task_list_cache[task.task_list_id]
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

    # finds person_id in given project
    def find_person_id(project_permalink)
      project_people = @client.project_people(project_permalink)
      project_people.find { |person| person.user_id == @client.account.id }.id
    end

    def log(text)
      puts text if @config['output_info']
    end

end

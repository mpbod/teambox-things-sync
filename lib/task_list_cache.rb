class TaskListCache
  
  def initialize(client, project_name)
    @data = {}
    @client = client
    @project_name = project_name
  end

  def [](task_list_id)
    if @data[task_list_id].nil?
      @data[task_list_id] = @client.project_task_list(@project_name, task_list_id).name
    end
    @data[task_list_id]
  end
end
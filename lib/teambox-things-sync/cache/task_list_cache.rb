module TeamboxThingsSync
  module Cache
    class TaskListCache < BaseCache
      def query_api(id)
        @client.project_task_list(@config[:project_permalink], id).name
      end
    end
  end
end
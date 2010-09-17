module TeamboxThingsSync
  # saves unnecessary API queries for task list names
  module Cache
    class BaseCache
      def initialize(client, config = {})
        @data = {}
        @client = client
        @config = config
      end

      def [](id)
        if @data[id].nil?
          @data[id] = query_api(id)
        end
        @data[id]
      end
    end
  end
end

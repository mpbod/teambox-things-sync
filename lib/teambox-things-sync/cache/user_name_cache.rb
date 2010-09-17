module TeamboxThingsSync
  module Cache
    class UserNameCache < BaseCache
      def query_api(id)
        user = @client.user(id)
        "#{user.first_name} #{user.last_name}"
      end
    end
  end
end
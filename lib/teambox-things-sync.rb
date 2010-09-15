require 'teambox-client'
require 'things'
require 'time'
require 'timeout'

module TeamboxThingsSync
  autoload :Base, File.dirname(__FILE__) + '/teambox-things-sync/base'
  autoload :ConfigStore, File.dirname(__FILE__) + '/teambox-things-sync/config_store'
  autoload :TaskListCache, File.dirname(__FILE__) + '/teambox-things-sync/task_list_cache'
end

module Things
   additional_properties = %{properties :tag_names, :due_date}
   Todo.module_eval(additional_properties)
end
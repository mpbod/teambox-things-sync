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
  # adds additional properties that doesn't exist in original gem
  additional_properties = %{properties :tag_names, :due_date}
  Todo.module_eval(additional_properties)

  class Todo

    # moves todo to Today list if it's due today or in the past
    def move_to_correct_list
      tomorrow_midnight = Time.parse((Date.today+1).to_s)
      if self.due_date && self.due_date < tomorrow_midnight
        self.move(Things::List.today)
      end
    end
  end
end
require 'teambox-client'
require 'things'
require 'time'
require 'timeout'

module TeamboxThingsSync
  autoload :Base, File.dirname(__FILE__) + '/teambox-things-sync/base'
  autoload :ConfigStore, File.dirname(__FILE__) + '/teambox-things-sync/config_store'
  module Cache
    autoload :BaseCache, File.dirname(__FILE__) + '/teambox-things-sync/cache/base_cache'
    autoload :TaskListCache, File.dirname(__FILE__) + '/teambox-things-sync/cache/task_list_cache'
    autoload :UserNameCache, File.dirname(__FILE__) + '/teambox-things-sync/cache/user_name_cache'
  end
end

module Things
  # adds additional properties that doesn't exist in original gem
  additional_properties = %{properties :tag_names, :due_date}
  Todo.module_eval(additional_properties)
  
  class Todo
    
    attr_accessor :was_in_today
    
    # Moves todo to Today list if it's due today or in the past, or user
    # put it there manually
    def move_to_today_if_necessary
      tomorrow_midnight = Time.parse((Date.today+1).to_s)
      if (self.due_date && self.due_date < tomorrow_midnight) || was_in_today
        self.move(Things::List.today)
      end
    end
    
    def remember_today_listing
      @was_in_today = Things::Todo.today.any? {|t| t.name == self.name}
    end
    
    def self.find(name_or_id)
      todo = super
      todo.remember_today_listing if todo
      return todo
    end
    
    def save
      todo = super
      todo.move_to_today_if_necessary if todo
      return todo
    end
  end
end
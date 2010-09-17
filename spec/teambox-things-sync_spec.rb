require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TeamboxThingsSync do
  pending
end

describe "Things::Todo" do
  
  describe "#move_to_correct_list" do
  
    before do
      Things::App.instance.empty_trash
      @todo = TeamboxThingsSync::Base.find_or_create_todo_in_things('TEST - Foo')
    end
  
    it "should be moved to Today if due date is today" do
      @todo.due_date = Time.now
      @todo.save
      @todo.move_to_correct_list
      Things::names_of_todos_in_today_list.should include(@todo.name)
    end
  
    it "should be moved to Today if due date is in the past" do
      @todo.due_date = Time.now-60*60*24*2
      @todo.save
      @todo.move_to_correct_list
      Things::names_of_todos_in_today_list.should include(@todo.name)
    end
  
    it "should not be moved to Today if due date is in the future" do
      @todo.due_date = Time.now+60*60*24
      @todo.save
      @todo.move_to_correct_list
      Things::names_of_todos_in_today_list.should_not include(@todo.name)
    end
    
    it "should not be moved to Next if user put it manually into Today" do
      @todo.save
      @todo.move(Things::List.today)
      @todo.move_to_correct_list
      Things::names_of_todos_in_today_list.should include(@todo.name)
    end
  
    after do
      @todo.delete
      Things::App.instance.empty_trash
    end
    
  end
  
end
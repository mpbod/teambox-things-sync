require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Things::Todo" do
  
  describe "#move_to_today_if_necessary" do
  
    before do
      Things::App.instance.empty_trash
      @todo = TeamboxThingsSync::Base.find_or_create_todo_in_things('TEST - Foo')
    end
  
    it "should be moved to Today if due date is today" do
      @todo.due_date = Time.now
      @todo.save
      Things::names_of_todos_in_today_list.should include(@todo.name)
    end
  
    it "should be moved to Today if due date is in the past" do
      @todo.due_date = Time.now-60*60*24*2
      @todo.save
      Things::names_of_todos_in_today_list.should include(@todo.name)
    end
  
    it "should not be moved to Today if due date is in the future" do
      @todo.due_date = Time.now+60*60*24
      @todo.save
      Things::names_of_todos_in_today_list.should_not include(@todo.name)
    end
    
    it "should be moved to Today if user put it manually into Today and then it was resetted by Things::Todo" do
      @todo.save
      @todo.move(Things::List.today)
      @todo = TeamboxThingsSync::Base.find_or_create_todo_in_things('TEST - Foo')
      @todo.save
      Things::names_of_todos_in_today_list.should include(@todo.name)
    end
  
    after do
      @todo.delete
      Things::App.instance.empty_trash
    end
    
  end
  
  describe "#remember_today_listing" do
    
    before do
      Things::App.instance.empty_trash
      @todo = TeamboxThingsSync::Base.find_or_create_todo_in_things('TEST - Foo')
      @todo.save
    end
    
    it "should return true if todo existed in Today before updating" do
      @todo.move(Things::List.today)
      @todo = TeamboxThingsSync::Base.find_or_create_todo_in_things('TEST - Foo')
      @todo.save
      @todo.was_in_today.should be_true
    end
    
    it "should return false if todo didn't exist in Today before updating" do
      @todo = TeamboxThingsSync::Base.find_or_create_todo_in_things('TEST - Foo')
      @todo.save
      @todo.was_in_today.should be_false
    end
    
    after do
      @todo.delete
      Things::App.instance.empty_trash
    end
  
  end
  
end
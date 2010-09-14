require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TeamboxThingsSync do
  
  describe "#task_url" do
    it "should return correct url to task" do
      config = {"teambox_url" => "http://testteambox.com"}
      sync = TeamboxThingsSync.new(config)
      sync.task_url("proj", "1", "2").should ==
        "http://testteambox.com/projects/proj/task_lists/1/tasks/2"
    end
  end
  
  describe "#.find_or_create_project_in_things" do
    
    it "should find project by name in Things" do
      Things::Project.should_receive(:find).with("testowy").and_return(true)
      TeamboxThingsSync.find_or_create_project_in_things("testowy")
    end
    
    it "should create new project in Things if it doesn't exist" do
      Things::Project.should_receive(:find).with("testowy").and_return(false)
      Things::Project.should_receive(:create).with(:name => "testowy").and_return(true)
      TeamboxThingsSync.find_or_create_project_in_things("testowy")
    end
  end
  
  describe "#.find_or_create_todo_in_things" do
    
    it "should find todo by name in Things" do
      Things::Todo.should_receive(:find).with("testowe").and_return(true)
      TeamboxThingsSync.find_or_create_todo_in_things("testowe")
    end
    
    it "should create new todo in Things if it doesn't exist" do
      Things::Todo.should_receive(:find).with("testowe").and_return(false)
      Things::Todo.should_receive(:create).with(:name => "testowe").and_return(true)
      TeamboxThingsSync.find_or_create_todo_in_things("testowe")
    end
  end
  
  
end

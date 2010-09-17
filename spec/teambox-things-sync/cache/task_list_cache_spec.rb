require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "TeamboxThingsSync::Cache::TaskListCache" do
  it "should query teambox api, get and return task name" do
    @client = double
    to_return = Hashie::Mash.new(:name => "test")
    
    task_list_cache = TeamboxThingsSync::Cache::TaskListCache.new(@client, 
      {:project_permalink => "testing"})
    @client.should_receive(:project_task_list).with("testing", 1).
      and_return(to_return)
    task_list_cache[1].should == "test"
  end
end

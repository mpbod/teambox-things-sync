require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "TeamboxThingsSync::Cache::UserNameCache" do
  it "should query teambox api, get and return user name" do
    @client = double
    to_return = Hashie::Mash.new(:first_name => "John", :last_name => "Smith")
    
    user_name_cache = TeamboxThingsSync::Cache::UserNameCache.new(@client)
    @client.should_receive(:user).with(22).
      and_return(to_return)
    user_name_cache[22].should == "John Smith"
    @client.should_not_receive(:user)
    user_name_cache[22]
  end
end

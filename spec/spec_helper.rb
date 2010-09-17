require 'rubygems'
require "bundler/setup"
require 'teambox-client'
require 'things'
require 'time'
require 'timeout'
require 'rspec'

Dir["#{File.dirname(__FILE__)}/../lib/*.rb"].each {|f| require f}

module Things
  def self.names_of_todos_in_today_list
    Things::App.lists.today.reference.todos.name.get
  end
end
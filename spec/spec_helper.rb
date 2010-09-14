require 'rubygems'
require "bundler/setup"
require 'teambox-client'
require 'things'
require 'time'
require 'timeout'
require 'rspec'
Dir["#{File.dirname(__FILE__)}/../lib/*.rb"].each {|f| require f}
require 'rubygems'
require "bundler/setup"
require 'teambox-client'
require 'things'
require 'time'
require 'timeout'
require File.join(File.dirname(__FILE__), 'lib', 'config_store')
require File.join(File.dirname(__FILE__), 'lib', 'task_list_cache')
require File.join(File.dirname(__FILE__), 'lib', 'teambox_things_sync')

config = ConfigStore.new("#{ENV['HOME']}/.teambox")
config['teambox_url'] ||= "http://teambox.com"
config['output_info'] ||= true
config['timeout_limit'] ||= 40
    
Timeout::timeout(config['timeout_limit']) {
  synchroniser = TeamboxThingsSync.new(config)
  synchroniser.synchronise
}

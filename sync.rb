require 'rubygems'
require "bundler/setup"
require 'teambox-client'
require 'things'
require 'time'
require 'timeout'
require File.join(File.dirname(__FILE__), 'lib', 'config_store')
require File.join(File.dirname(__FILE__), 'lib', 'task_list_cache')
require File.join(File.dirname(__FILE__), 'lib', 'teambox_things_sync')



synchroniser = TeamboxThingsSync::Base.new
synchroniser.synchronise

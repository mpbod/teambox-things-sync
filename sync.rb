require 'rubygems'
require File.join(File.dirname(__FILE__), 'lib', 'teambox-things-sync')

TeamboxThingsSync::Base.new.synchronise

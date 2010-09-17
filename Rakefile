begin
  require 'rubygems'
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "teambox-things-sync"
    gemspec.summary = "Simple ruby app for Teambox and Things.app syncing"
    gemspec.email = "fastred@fastred.org"
    gemspec.homepage = "http://github.com/fastred/teambox-things-sync"
    gemspec.authors = ["Arkadiusz Holko"]
    gemspec.add_development_dependency "rspec", ">=2.0.0.beta.20"
    gemspec.add_dependency "teambox-client", "0.2.0"
    gemspec.add_dependency "things-client", "0.2.4"
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

namespace :command do
  desc "Run command with using current folder files (not gem)'"
  task :test do
    require 'lib/teambox-things-sync.rb'
    require 'lib/teambox-things-sync/command'
  end
end
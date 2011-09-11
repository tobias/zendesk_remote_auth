require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "zendesk_remote_auth"
    gem.summary = %Q{Helper for Zendesk SSO/remote authentication}
    gem.description = %Q{See the README.}
    gem.email = "tcrawley@gmail.com"
    gem.homepage = "http://github.com/tobias/zendesk_remote_auth"
    gem.authors = ["Tobias Crawley"]
    gem.add_dependency "active_support", ">= 3.0.0"
    gem.add_development_dependency "rspec", ">= 2.6.0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end

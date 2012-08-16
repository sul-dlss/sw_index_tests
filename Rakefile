require 'bundler/setup'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rspec/core/rake_task'

desc "run specs" 
RSpec::Core::RakeTask.new(:rspec) do |spec|
  spec.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb", "-t ~chinese", "-t ~japanese"]
end

task :spec => :rspec
task :default => :rspec

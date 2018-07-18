require 'bundler/setup'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rspec/core/rake_task'

desc "run specs expected to pass"
RSpec::Core::RakeTask.new(:spec)

desc "run specs NOT expected to pass"
RSpec::Core::RakeTask.new(:fixme) do |spec|
  spec.rspec_opts = ["-t pending:fixme"]
end

desc "run ALL specs, including fixme"
RSpec::Core::RakeTask.new(:all_but_cjk) do |spec|
  spec.rspec_opts = ["-t ~chinese", "-t ~japanese", "-t ~korean"]
end

desc "run only (all) CJK specs"
RSpec::Core::RakeTask.new(:cjk) do |spec|
  spec.rspec_opts = ["-t chinese", "-t japanese", "-t korean"]
end

desc "run only Chinese specs"
RSpec::Core::RakeTask.new(:zh) do |spec|
  spec.rspec_opts = ["-t chinese"]
end

desc "run only japanese specs"
RSpec::Core::RakeTask.new(:ja) do |spec|
  spec.rspec_opts = ["-t japanese"]
end

desc "run only korean specs"
RSpec::Core::RakeTask.new(:ko) do |spec|
  spec.rspec_opts = ["-t korean"]
end


task :default => :spec

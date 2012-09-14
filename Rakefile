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
RSpec::Core::RakeTask.new(:passing) do |spec|
  spec.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb", "-t ~fixme", "#{ENV['ROPTS']}"]
end

#desc "run spec expected to pass and send output to file" 
#RSpec::Core::RakeTask.new(:passing_to_file) do |spec|
#  spec.rspec_opts = ["-f documentation", "-r ./spec/spec_helper.rb", "-t ~fixme"] 
#end

desc "run specs NOT expected to pass" 
RSpec::Core::RakeTask.new(:fixme) do |spec|
  spec.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb", "-t fixme", "#{ENV['ROPTS']}"] 
end

desc "run specs NOT expected to pass with output in 'documentation' format" 
RSpec::Core::RakeTask.new(:fixme_doc) do |spec|
  spec.rspec_opts = ["-c", "-f documentation", "-r ./spec/spec_helper.rb", "-t fixme", "#{ENV['ROPTS']}"] 
end

desc "run specs NOT expected to pass with output in 'html' format" 
RSpec::Core::RakeTask.new(:fixme_html) do |spec|
  spec.rspec_opts = ["-c", "-f documentation", "-r ./spec/spec_helper.rb", "-t fixme", "#{ENV['ROPTS']}"] 
end

desc "run only (all) CJK specs" 
RSpec::Core::RakeTask.new(:cjk) do |spec|
  spec.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb", "-t chinese", "-t japanese", "-t korean", "#{ENV['ROPTS']}"] 
end

desc "run only japanese specs" 
RSpec::Core::RakeTask.new(:ja) do |spec|
  spec.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb", "-t japanese", "#{ENV['ROPTS']}"] 
end

desc "run CJK wordbreak specs" 
RSpec::Core::RakeTask.new(:wb) do |spec|
  spec.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb", "-t fixme", "#{ENV['ROPTS']}"] 
end

desc "run CJK wordbreak specs with output in 'documentation' format" 
RSpec::Core::RakeTask.new(:wb_doc) do |spec|
  spec.rspec_opts = ["-c", "-f documentation", "-r ./spec/spec_helper.rb", "-t fixme", "#{ENV['ROPTS']}"] 
end

desc "run CJK wordbreak specs with output in 'html' format" 
RSpec::Core::RakeTask.new(:wb_html) do |spec|
  spec.rspec_opts = ["-c", "-f documentation", "-r ./spec/spec_helper.rb", "-t fixme", "#{ENV['ROPTS']}"] 
end


task :spec => :passing
task :rspec => :passing
task :default => :passing

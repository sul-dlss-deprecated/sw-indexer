# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

task :default do
  Rake::Task['spec'].invoke
end

task :spec do
  begin
    require 'rspec/core/rake_task'
    RSpec::Core::RakeTask.new(:rspec)
    Rake::Task['rspec'].invoke
  rescue LoadError
    desc 'rspec unavailable'
    abort 'rspec not installed'
  end
end

desc 'Run rubocop on ruby files'
task :rubocop do
  begin
    require 'rubocop/rake_task'
    RuboCop::RakeTask.new(:rubocop) do |task|
      task.options = ['-l'] # run lint cops only
    end
  rescue LoadError
    # this rescue block is here for deployment to production, where rubocop
    # in not installed, and it's not a problem
    STDERR.puts 'WARNING: Rubocop was not found and could not be required.'
  end
end

desc 'Run continuous integration suite (tests, coverage, rubocop)'
task :ci do
  Rake::Task['rubocop'].invoke
  Rake::Task['spec'].invoke
end

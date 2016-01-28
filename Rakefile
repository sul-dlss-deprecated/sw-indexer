# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.options = ['-l'] # run lint cops only
  end

  desc "run specs and rubocop"
  task :default do
    # runs specs from inherited default rake task
    Rake::Task[:rubocop].invoke
  end
rescue LoadError
  # this rescue block is here for deployment to production, where rubocop
  # in not installed, and it's not a problem
  STDERR.puts 'WARNING: Rubocop was not found and could not be required.'
end

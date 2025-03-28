require 'resque/tasks'
require 'resque/scheduler/tasks'

namespace :resque do
  task setup: :environment do
    require 'resque'
    require 'resque-scheduler'
  end

  task setup_schedule: :setup do
    require 'resque-scheduler'
    Resque::Scheduler.dynamic = true
  end

  task scheduler: :setup_schedule do
    # Run the scheduler
    Resque::Scheduler.start
  end
end

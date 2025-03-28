# app/jobs/hard_worker.rb
class HardWorker
    @queue = :default
  
    def self.perform(task, seconds)
      puts "Starting task: #{task}. Sleeping for #{seconds} seconds..."
      sleep(seconds)  # Simulate a long-running process
      puts "Completed task: #{task}"
    end
  end
  
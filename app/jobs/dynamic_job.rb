# app/jobs/dynamic_job.rb

class DynamicJob
    @queue = :default
  
    def self.perform(message)
        puts "DynamicJob executing: #{message}"
        sleep 10  # simulate a 10-second job for testing
        puts "DynamicJob completed"
    end
  end
  
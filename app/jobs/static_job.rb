# app/jobs/static_job.rb

class StaticJob
    @queue = :default
  
    def self.perform(message)
      puts "StaticJob executed with message: #{message}"
      # Your static job logic here.
    end
  end
  
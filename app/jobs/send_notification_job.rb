class SendNotificationJob
    # Specify the queue for this job
    @queue = :default
  
    # The perform method is called by Resque workers
    def self.perform(message)
      # Your notification logic here
      puts "Sending notification to user : #{message}"
    end
  end
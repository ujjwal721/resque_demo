# lib/tasks/scheduled_jobs.rake

namespace :scheduled_jobs do
    desc "Enqueue scheduled jobs from the database"
    task enqueue: :environment do
      # Replace with your condition, here using soft_delete = 0 to pick active jobs
      ScheduledJob.where(enabled:true).find_each do |job_record|
        begin
          # Convert job_class from string to actual Ruby class
          job_class = job_record.job_class.constantize
          
          # Parse parameters stored in JSON (if applicable)
          args = JSON.parse(job_record.parameters) rescue job_record.parameters
          args = Array(args)  # Ensure it is an array
          
          # Enqueue the job to its default queue (you can adjust if needed)
          Resque.enqueue(job_class, *args)
          
          # Optionally, update a timestamp field (like last_enqueued_at) if you have one
        #   job_record.update(last_enqueued_at: Time.current)
          puts "Enqueued #{job_record.job_class} with args #{args.inspect}"
        rescue StandardError => e
          puts "Error enqueuing job id #{job_record.id}: #{e.message}"
        end
      end
      puts "All eligible jobs have been enqueued."
    end
  end
  
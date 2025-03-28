namespace :scheduled_jobs do
    desc "Update next_run_time for existing ScheduledJob records"
    task update_next_run_time: :environment do
      ScheduledJob.find_each do |job|
        # Set next_run_time to the beginning of the hour of creation (adjust as needed)
        next_run = job.created_at.beginning_of_hour
        job.update(next_run_time: next_run)
        puts "Updated job #{job.id} with next_run_time #{next_run}"
      end
    end
  end
  
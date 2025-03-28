class ScheduledJobPoller
  @queue = :poller_queue

  def self.perform
    # Fetch only jobs that are due (next_run_time is past) and haven't been enqueued in this interval.
    ScheduledJob.where(
      "enabled = ? AND next_run_time <= ? AND (last_enqueued_at IS NULL OR last_enqueued_at < next_run_time)",
      true, Time.current
    ).find_each do |job_record|
      begin
        # Convert the stored job_class string into a Ruby constant.
        job_class = job_record.job_class.constantize

        # Parse parameters (if in JSON) and ensure they are an array.
        args = JSON.parse(job_record.parameters) rescue job_record.parameters
        args = Array(args)

        # Enqueue the job into Resque. Pass the job_record id if needed for later updates.
        Resque.enqueue(job_class, job_record.id, *args)

        # After enqueueing, update last_enqueued_at and advance next_run_time by the fixed interval (e.g., 1 hour).
        next_slot = job_record.next_run_time + 1.hour
        job_record.update(last_enqueued_at: Time.current, next_run_time: next_slot)

        puts "Enqueued #{job_record.job_class} (ID: #{job_record.id}) with args #{args.inspect}, next run at #{next_slot}"
      rescue StandardError => e
        puts "Error enqueuing job #{job_record.id}: #{e.message}"
      end
    end

    # Sleep for a short interval before re-enqueuing the poller.
    sleep 30
    Resque.enqueue(self)
  end
end

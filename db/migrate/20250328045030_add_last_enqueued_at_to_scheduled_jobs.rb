class AddLastEnqueuedAtToScheduledJobs < ActiveRecord::Migration[8.0]
  def change
    add_column :scheduled_jobs, :last_enqueued_at, :datetime
  end
end

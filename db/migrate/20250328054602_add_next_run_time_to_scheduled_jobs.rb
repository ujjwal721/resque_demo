class AddNextRunTimeToScheduledJobs < ActiveRecord::Migration[8.0]
  def change
    add_column :scheduled_jobs, :next_run_time, :datetime
  end
end

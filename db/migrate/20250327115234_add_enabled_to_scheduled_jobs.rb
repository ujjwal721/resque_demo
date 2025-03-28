class AddEnabledToScheduledJobs < ActiveRecord::Migration[8.0]
  def change
    add_column :scheduled_jobs, :enabled, :boolean, default: true, null: false
  end
end

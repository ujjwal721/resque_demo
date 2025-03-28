class CreateScheduledJobs < ActiveRecord::Migration[8.0]
  def change
    create_table :scheduled_jobs do |t|
      t.string :job_class
      t.text :parameters
      t.string :schedule_type
      t.string :schedule_value
      t.string :created_by
      t.integer :soft_delete,    null: false, default: 0
      t.timestamps
    end
  end
end

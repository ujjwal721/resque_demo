class CreateJobSchedules < ActiveRecord::Migration[8.0]
  def change
    create_table :job_schedules do |t|
      t.string  :job_name,    null: false
      t.string  :job_class,   null: false
      t.string  :cron,        null: false
      t.text    :args
      t.text    :description
      t.boolean :enabled,     default: true

      t.timestamps
    end
  end
end

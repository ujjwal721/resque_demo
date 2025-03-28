# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb
# db/seeds.rb

# Job 1: dynamic_job
ScheduledJob.create!(
  job_class: "DynamicJob",
  parameters: {
    description: "A job that runs every 30 seconds",
    queue: "default",
    arguments: "Hello from DynamicJob!"
  }.to_json,
  schedule_type: "every",
  schedule_value: "30s",
  created_by: "admin"  # ya koi bhi default value
)

# Job 2: hard_worker_job
ScheduledJob.create!(
  job_class: "HardWorker",
  parameters: {
    description: "This job runs every minute using Resque Scheduler.",
    queue: "default",
    arguments: ["Scheduled Task", 5]
  }.to_json,
  schedule_type: "cron",
  schedule_value: "*/1 * * * *",
  created_by: "admin"
)

# Job 3: send_daily_notifications
ScheduledJob.create!(
  job_class: "SendNotificationJob",
  parameters: {
    description: "send_daily_notifications",
    queue: "notifications",
    arguments: "Daily update"
  }.to_json,
  schedule_type: "cron",
  schedule_value: "0 0 * * *",
  created_by: "admin"
)

# Job 4: static_job
ScheduledJob.create!(
  job_class: "StaticJob",
  parameters: {
    description: "A static job that runs every 5 minutes.",
    queue: "default",
    arguments: "Hello from StaticJob!"
  }.to_json,
  schedule_type: "cron",
  schedule_value: "*/1 * * * *",  # yahan note karein: table header mein 5 minutes likha hai, par value cron expression every minute dikha rahi hai
  created_by: "admin"
)

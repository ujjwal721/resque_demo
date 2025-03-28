require 'faker'
require 'json'


num_requests = 1000

File.open("update_requests.sh", "w") do |file|
  num_requests.times do |i|
    # Generate a random job ID between 1 and 1000 (adjust range as needed)
    job_id = rand(1..1000)
    
    # Randomly choose a job class (ensure these classes exist in your app)
    job_class = ["DynamicJob", "HardWorker", "StaticJob"].sample

    # Generate random parameters as a JSON array (you can adjust as needed)
    parameters = [Faker::Lorem.word, rand(1..100)].to_json

    # Randomly choose a schedule type
    schedule_type = ["cron", "every"].sample

    # Generate schedule_value based on schedule type
    if schedule_type == "cron"
      # A simple cron expression: every N minutes (between 1 and 5)
      schedule_value = "*/#{rand(1..5)} * * * *"
    else
      # For "every" type, generate a value like "30s" or "45s"
      schedule_value = "#{rand(30..60)}s"
    end

    # Generate a random created_by email
    created_by = Faker::Internet.email

    # Create the JSON payload
    payload = {
      scheduled_job: {
        job_class: job_class,
        parameters: parameters,
        schedule_type: schedule_type,
        schedule_value: schedule_value,
        created_by: created_by
      }
    }.to_json

    # Build the curl command (using -s for silent mode)
    curl_command = "curl -s -X PUT -H \"Content-Type: application/json\" -H \"Accept: application/json\" -d '#{payload}' http://localhost:3000/scheduled_jobs/#{job_id}"
    
    # Write the command to file
    file.puts curl_command
  end
end

puts "Generated #{num_requests} update request commands in update_requests.sh"

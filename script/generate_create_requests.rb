require 'faker'
require 'json'

# Number of create requests to generate
num_requests = 1000

# Open a file to write the curl commands
File.open("create_requests.sh", "w") do |file|
  num_requests.times do
    # Randomly choose a job class (ensure these classes exist in your app)
    job_class = ["DynamicJob", "HardWorker", "StaticJob"].sample

    # Generate random parameters as a JSON array
    parameters = [Faker::Lorem.word, rand(1..100)].to_json

    # Randomly choose a schedule type
    schedule_type = ["cron", "every"].sample

    # Generate schedule_value based on schedule type
    schedule_value = if schedule_type == "cron"
      # A simple cron expression: every N minutes (N between 1 and 5)
      "*/#{rand(1..5)} * * * *"
    else
      # For "every" type, generate a value like "30s" to "60s"
      "#{rand(30..60)}s"
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
    curl_command = "curl -s -X POST -H \"Content-Type: application/json\" -H \"Accept: application/json\" -d '#{payload}' http://localhost:3000/scheduled_jobs"
    
    # Write the command to the file
    file.puts curl_command
  end
end

puts "Generated #{num_requests} create request commands in create_requests.sh"

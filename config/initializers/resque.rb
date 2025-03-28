require 'resque'
require 'resque-scheduler'

# Configure Redis. Optionally, use an environment variable to set the Redis URL.
redis_url = ENV["REDIS_URL"] || "redis://localhost:6379"
Resque.redis = Redis.new(url: redis_url)
Resque::Scheduler.dynamic = true
Resque.schedule = YAML.load_file(Rails.root.join('config', 'resque_schedule.yml')) if File.exist?(Rails.root.join('config', 'resque_schedule.yml'))
#Resque.schedule = YAML.load_file(Rails.root.join("config/resque_schedule.yml"))
#Resque.schedule = YAML.load_file(Rails.root.join("config", "resque_schedule.yml")) if File.exist?(Rails.root.join("config", "resque_schedule.yml"))
# config/initializers/resque.rb
# if File.exist?(Rails.root.join('config', 'resque_schedule.yml'))
#     Resque.schedule = YAML.load_file(Rails.root.join('config', 'resque_schedule.yml'))
#   end
  
  # Later (e.g., via a controller or initializer), add dynamic schedules:
  
  
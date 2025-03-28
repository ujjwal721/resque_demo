schedule_definition = {
  "every"       => ["30s"],
  "class"       => "DynamicJob",
  "queue"       => "default",
  "description" => "A dynamically scheduled job that runs every 30 seconds.",
  "args"        => ["Hello from DynamicJob!"]
}

Resque.set_schedule("dynamic_job", schedule_definition)
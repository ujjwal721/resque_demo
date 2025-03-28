# README

The Problem Scenario
Scheduled Job Example:
You have a job that should run every hour on the hour (e.g., 12:00, 13:00, 14:00, etc.).

Failure and Manual Fix:
Suppose the 12:00 job fails. You fix the issue and manually reprocess or re-enqueue the job at 12:10.
Despite the job being executed at 12:10, you want the subsequent scheduled run to remain on its fixed slot—in this case, 13:00, not 12:10 + 1 hour (which would be 13:10).

Each job is assigned a fixed time slot using a field such as next_run_time in your ScheduledJob model.
For example, if a job was originally scheduled for 12:00, its next_run_time is set to 12:00.

Updating the Schedule:
After processing a job, instead of basing the next run on the current time, you update the next run time based on the previous scheduled slot.
For instance, if a job originally scheduled for 12:00 is fixed and processed at 12:10, the next scheduled time is calculated as:
next_slot = job_record.next_run_time + 1.hour
This ensures that the next run is set to 13:00 (i.e., 12:00 + 1 hour) regardless of the actual processing time.

How It Works
Job Fetching:
The worker retrieves all enabled jobs whose next_run_time is less than or equal to the current time. This ensures that only jobs that are due for processing are selected.

Job Processing:
Each job's class is resolved (using constantize), parameters are parsed, and the job is enqueued using Resque.
In our scenario, even if the job originally scheduled for 12:00 is processed at 12:10 (after being fixed), the worker still uses the original next_run_time (12:00) to calculate the next slot.

Fixed Schedule Update:
The next scheduled run is computed by adding a fixed interval (1 hour) to the previous next_run_time.
Thus, despite a 12:10 processing time, the next scheduled run will be 13:00 (12:00 + 1.hour), keeping the schedule intact.





class ScheduledJobsController < ApplicationController
  skip_before_action :verify_authenticity_token
  # POST /scheduled_jobs
  def create
    @job = ScheduledJob.new(scheduled_job_params)
    if @job.save
      set_resque_schedule(@job)
      render json: @job, status: :created
    else
      render json: @job.errors, status: :unprocessable_entity
    end
  end

  # PUT /scheduled_jobs/:id
  def update
    @job = ScheduledJob.find(params[:id])
    if @job.update(scheduled_job_params)
      set_resque_schedule(@job)
      render json: @job, status: :ok
    else
      render json: @job.errors, status: :unprocessable_entity
    end
  end

  # DELETE (soft delete) /scheduled_jobs/:id
  def destroy
    @job = ScheduledJob.find(params[:id])
    # Remove the schedule from Resque
    Resque.remove_schedule("job_#{@job.id}")
    # Soft delete by setting soft_delete to 1
    if @job.update(soft_delete: 1)
      render json: { message: "Job soft-deleted successfully." }, status: :ok
    else
      render json: @job.errors, status: :unprocessable_entity
    end
  end

  private

  def scheduled_job_params
    params.require(:scheduled_job).permit(:job_class, :parameters, :schedule_type, :schedule_value, :created_by)
  end

  # Helper method to set or update the schedule in Resque
  def set_resque_schedule(job)
    schedule_definition = if job.schedule_type.downcase == "cron"
      {
        "cron"        => job.schedule_value,
        "class"       => job.job_class,
        "queue"       => "default",
        "description" => "Job scheduled via API",
        "args"        => job.parsed_parameters
      }
    else  # assume "every"
      {
        "every"       => [job.schedule_value],
        "class"       => job.job_class,
        "queue"       => "default",
        "description" => "Job scheduled via API",
        "args"        => job.parsed_parameters
      }
    end
  
    Rails.logger.info "Setting Resque schedule for job_#{job.id}: #{schedule_definition.inspect}"
    Resque.set_schedule("job_#{job.id}", schedule_definition)
  end
end

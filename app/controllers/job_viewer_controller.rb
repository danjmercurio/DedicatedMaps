class JobViewerController < ApplicationController
  # Basic list of all DelayedJobs on the system. Just gets a count
  # and displays any errors.
  def index
    jobs = Delayed::Job.all
    @job_count = jobs.count

    @errors = jobs.map { |job| job.last_error }.compact

  end
end

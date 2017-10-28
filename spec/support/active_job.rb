RSpec.configure do |config|
  config.include ActiveJob::TestHelper

  config.before(:each) do
    clear_enqueued_jobs
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
  end
end

ActiveJob::Base.queue_adapter = :test

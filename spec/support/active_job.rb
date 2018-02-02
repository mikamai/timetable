# frozen_string_literal: true

RSpec.configure do |config|
  config.before :each do
    ActiveJob::Base.queue_adapter.enqueued_jobs.clear
  end
end

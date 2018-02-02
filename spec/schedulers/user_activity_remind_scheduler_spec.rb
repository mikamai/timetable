# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserActivityRemindScheduler do
  it 'sends an email to each user that did not track enough hours' do
    create :project_member
    expect {
      subject.perform
    }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :length).by 1
  end

  it 'ignores users without a project' do
    create :time_entry
    ProjectMember.destroy_all
    expect {
      subject.perform
    }.not_to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :length)
  end

  it 'ignores users with enough time' do
    create :time_entry, amount: 2399
    create :time_entry, amount: 2401
    expect {
      subject.perform
    }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :length).by 1
  end
end

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
    user = create :user, :organized
    create_list :time_entry, 2, amount: 1440, user: user, organization: user.organizations.first
    create :time_entry, amount: 1000
    expect {
      subject.perform
    }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :length).by 1
  end
end

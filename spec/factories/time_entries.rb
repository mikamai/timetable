# frozen_string_literal: true

FactoryBot.define do
  factory :time_entry do
    transient do
      organization { create :organization }
    end

    user { create :user, :organized, organization: organization }
    project { create :project, organization: organization, users: [user] }
    task { create :task, organization: organization, projects: [project] }
    executed_on { Date.today }
    amount 1
  end
end

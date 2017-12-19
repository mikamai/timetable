# frozen_string_literal: true

FactoryBot.define do
  factory :time_entry do
    transient do
      organization { create :organization }
    end

    project { build :project, organization: organization }
    user { create :user, :organized, organization: organization }
    task { build :task, organization: organization }
    executed_on { Date.today }
    amount 1
  end
end

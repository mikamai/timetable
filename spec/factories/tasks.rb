# frozen_string_literal: true

FactoryBot.define do
  sequence(:task_name) { |n| "Task #{n}" }

  factory :task do
    organization
    name { generate :task_name }
  end
end

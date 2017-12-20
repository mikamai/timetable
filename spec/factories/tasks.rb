# frozen_string_literal: true

FactoryBot.define do
  sequence(:task_name) { |n| "Task #{n}" }

  factory :task do
    transient do
      projects []
    end

    organization
    name { generate :task_name }

    after :create do |task, e|
      e.projects.each { |p| task.projects << p }
    end
  end
end

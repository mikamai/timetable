# frozen_string_literal: true

FactoryBot.define do
  sequence(:project_name) { |n| "Project #{n}" }

  factory :project do
    organization
    client { build :client, organization: organization }
    name { generate :project_name }

    trait :with_tasks do
      transient do
        tasks_count 2
      end

      after :create do |project, e|
        e.tasks_count.times do
          project.tasks << create(:task, organization: project.organization)
        end
      end
    end
  end
end

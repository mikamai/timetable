# frozen_string_literal: true

FactoryBot.define do
  sequence(:project_name) { |n| "Project #{n}" }

  factory :project do
    transient do
      users []
    end

    organization
    client { build :client, organization: organization }
    name { generate :project_name }

    after :create do |project, e|
      e.users.each do |u|
        project.members << create(:project_member, project: project, user: u)
      end
    end

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

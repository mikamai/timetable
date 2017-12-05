# frozen_string_literal: true

FactoryBot.define do
  sequence(:project_name) { |n| "Project #{n}" }

  factory :project do
    organization
    name { generate :project_name }
  end
end

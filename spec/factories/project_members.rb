# frozen_string_literal: true

FactoryBot.define do
  factory :project_member do
    project
    user { create :user, :organized, organization: project.organization }
  end
end

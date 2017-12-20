# frozen_string_literal: true

FactoryBot.define do
  factory :organization_member do
    user
    organization
  end
end

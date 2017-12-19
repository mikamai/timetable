# frozen_string_literal: true

FactoryBot.define do
  sequence(:role_name) { |n| "role #{n}" }

  factory :role do
    organization
    name { generate :role_name }
  end
end

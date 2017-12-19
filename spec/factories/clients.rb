# frozen_string_literal: true

FactoryBot.define do
  sequence(:client_name) { |n| "Client #{n}" }

  factory :client do
    organization
    name { generate :client_name }
  end
end

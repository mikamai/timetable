# frozen_string_literal: true

FactoryBot.define do
  sequence(:user_email) { |n| "user_#{n}@mikamai.com" }

  factory :user do
    email { generate :user_email }
    password 'password'

    trait :admin do
      admin true
    end
  end
end

# frozen_string_literal: true

FactoryBot.define do
  sequence(:user_email) { |n| "user_#{n}@mikamai.com" }
  sequence(:user_last_name) { |n| "Surname#{n}" }

  factory :user do
    first_name 'NoName'
    last_name { generate :user_last_name }
    email { generate :user_email }
    password 'password'
    confirmed_at { 1.day.ago }

    trait :invited do
      confirmed_at nil
      invitation_created_at { 1.day.ago }
      invitation_sent_at { 1.day.ago }
      invitation_token 'asdasdasd'
    end

    trait :admin do
      admin true
    end

    trait :organized do
      transient do
        org_admin false
        organization { create :organization }
      end

      after :build do |user, e|
        user.organization_memberships.build organization: e.organization, admin: e.org_admin
      end
    end
  end
end

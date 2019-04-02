# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  admin                  :boolean          default(FALSE), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  openid_uid             :uuid
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invited_by_id          :uuid
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invitations_count     (invitations_count)
#  index_users_on_openid_uid            (openid_uid) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (invited_by_id => users.id)
#

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
        org_role 'user'
        organization { create :organization }
      end

      after :build do |user, e|
        user.organization_memberships.build organization: e.organization, role: e.org_role
      end
    end
  end
end

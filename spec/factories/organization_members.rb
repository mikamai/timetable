# frozen_string_literal: true
# == Schema Information
#
# Table name: organization_members
#
#  id              :bigint(8)        not null, primary key
#  role            :integer          default(0), not null
#  organization_id :uuid             not null
#  user_id         :uuid             not null
#
# Indexes
#
#  index_organization_members_on_organization_id_and_user_id  (organization_id,user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :organization_member do
    user
    organization
  end
end

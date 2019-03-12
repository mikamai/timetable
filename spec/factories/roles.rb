# frozen_string_literal: true

# == Schema Information
#
# Table name: roles
#
#  id              :uuid             not null, primary key
#  name            :string           not null
#  slug            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid             not null
#
# Indexes
#
#  index_roles_on_organization_id_and_slug  (organization_id,slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#


FactoryBot.define do
  sequence(:role_name) { |n| "role #{n}" }

  factory :role do
    organization
    name { generate :role_name }
  end
end

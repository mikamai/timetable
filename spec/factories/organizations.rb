# frozen_string_literal: true

# == Schema Information
#
# Table name: organizations
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  slug       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_organizations_on_slug  (slug) UNIQUE
#


FactoryBot.define do
  sequence(:organization_name) { |n| "Organization #{n}" }

  factory :organization do
    name { generate :organization_name }
  end
end

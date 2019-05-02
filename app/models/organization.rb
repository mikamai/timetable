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


class Organization < ApplicationRecord
  extend FriendlyId

  has_many :members, class_name: 'OrganizationMember', inverse_of: :organization
  has_many :users, through: :members
  has_many :projects, inverse_of: :organization
  has_many :time_entries, through: :projects
  has_many :time_off_entries, inverse_of: :organization
  has_many :time_off_periods, inverse_of: :organization
  has_many :tasks, inverse_of: :organization
  has_many :clients, inverse_of: :organization
  has_many :roles, inverse_of: :organization
  has_many :report_entries_exports, inverse_of: :organization

  accepts_nested_attributes_for :members, reject_if: :all_blank, allow_destroy: true

  friendly_id :name, use: %i[slugged finders]

  scope :by_name, -> { order :name }

  validates :name,
            presence: true,
            uniqueness: true
end

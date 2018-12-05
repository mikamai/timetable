# frozen_string_literal: true

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

  friendly_id :name, use: :slugged

  scope :by_name, -> { order :name }

  validates :name,
            presence: true,
            uniqueness: true
end

# frozen_string_literal: true

class Organization < ApplicationRecord
  extend FriendlyId

  has_many :members, class_name: 'OrganizationMember', inverse_of: :organization
  has_many :users, through: :members
  has_many :projects, inverse_of: :organization
  has_many :time_entries, through: :projects
  has_many :tasks, inverse_of: :organization
  has_many :clients, inverse_of: :organization
  has_many :roles, inverse_of: :organization

  friendly_id :name, use: :slugged

  validates :name,
            presence: true,
            uniqueness: true
end

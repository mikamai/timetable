# frozen_string_literal: true

class Project < ApplicationRecord
  extend FriendlyId

  belongs_to :organization, inverse_of: :projects
  has_many :members, class_name: 'ProjectMember', inverse_of: :project
  has_many :tasks, inverse_of: :project
  has_many :users, through: :members
  has_many :time_entries, through: :tasks

  friendly_id :name, use: :scoped, scope: :organization

  scope :in_organization, ->(organization) { where organization_id: organization.id }

  validates :name,
            presence: true,
            uniqueness: true

  delegate :name, to: :organization, prefix: true
end

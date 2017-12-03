# frozen_string_literal: true

class Project < ApplicationRecord
  extend FriendlyId

  belongs_to :organization
  has_many :project_memberships
  has_many :users, through: :project_memberships

  friendly_id :name, use: :scoped, scope: :organization

  validates :name,
            presence: true,
            uniqueness: true

  delegate :name, to: :organization, prefix: true
end

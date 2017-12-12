# frozen_string_literal: true

class Client < ApplicationRecord
  extend FriendlyId

  belongs_to :organization, inverse_of: :clients
  has_many :projects, inverse_of: :client

  friendly_id :name, use: :scoped, scope: :organization

  scope :in_organization, ->(organization) { where organization_id: organization.id }

  validates :name,
            presence: true,
            uniqueness: { scope: :organization_id }

  delegate :name, to: :organization, prefix: true
end

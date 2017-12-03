# frozen_string_literal: true

class Organization < ApplicationRecord
  extend FriendlyId

  has_many :organization_memberships

  friendly_id :name, use: :slugged

  validates :name,
            presence: true,
            uniqueness: true
end

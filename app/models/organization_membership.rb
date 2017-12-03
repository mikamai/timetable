# frozen_string_literal: true

class OrganizationMembership < ApplicationRecord
  belongs_to :organization
  belongs_to :user

  validates :organization,
            presence: true
  validates :user,
            presence: true
end

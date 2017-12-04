# frozen_string_literal: true

class OrganizationMembership < ApplicationRecord
  belongs_to :organization
  belongs_to :user

  validates :organization,
            presence: true
  validates :user,
            presence: true,
            uniqueness: { scope: :organization_id }

  delegate :email, to: :user, prefix: true

  def as_json opts = {}
    opts.reverse_merge!(
      only: %i[id admin],
      include: { user: { only: :email } }
    )
    super opts
  end
end

# frozen_string_literal: true

class OrganizationMember < ApplicationRecord
  belongs_to :organization, inverse_of: :members
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

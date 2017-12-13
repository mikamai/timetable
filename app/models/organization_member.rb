# frozen_string_literal: true

class OrganizationMember < ApplicationRecord
  belongs_to :organization, inverse_of: :members
  belongs_to :user, inverse_of: :organization_memberships

  scope :by_user_name, -> { includes(:user).order 'users.last_name', 'users.first_name' }

  validates :organization,
            presence: true
  validates :user,
            presence: true,
            uniqueness: { scope: :organization_id }

  delegate :name, to: :user, prefix: true

  def as_json opts = {}
    opts.reverse_merge!(
      only: %i[id admin],
      include: { user: { only: :email } }
    )
    super opts
  end
end

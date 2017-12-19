# frozen_string_literal: true

class OrganizationMember < ApplicationRecord
  belongs_to :organization, inverse_of: :members
  belongs_to :user, inverse_of: :organization_memberships

  scope :by_user_name, -> { includes(:user).order 'users.last_name', 'users.first_name' }

  validates :user,
            uniqueness: { scope: :organization_id }

  before_destroy :validate_references

  delegate :name, to: :user, prefix: true, allow_nil: true

  def self.policy_class
    Organized::OrganizationMemberPolicy
  end

  def user_email
    @user_email || user&.email
  end

  def user_email= email
    @user_email = email
    self.user = User.find_by(email: email) || User.invite!(email: email)
  end

  def as_json opts = {}
    opts.reverse_merge!(
      only: %i[id admin],
      include: { user: { only: :email } }
    )
    super opts
  end

  def destroyable?
    user.projects.in_organization(organization).empty?
  end

  private

  def validate_references
    return if destroyable?
    errors.add :base, 'is referenced by projects'
    throw :abort
  end
end

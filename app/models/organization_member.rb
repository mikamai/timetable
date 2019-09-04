# frozen_string_literal: true
# == Schema Information
#
# Table name: organization_members
#
#  id              :bigint(8)        not null, primary key
#  role            :integer          default("user"), not null
#  organization_id :uuid             not null
#  user_id         :uuid             not null
#
# Indexes
#
#  index_organization_members_on_organization_id_and_user_id  (organization_id,user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (user_id => users.id)
#

class OrganizationMember < ApplicationRecord
  belongs_to :organization, inverse_of: :members
  belongs_to :user, inverse_of: :organization_memberships

  scope :by_user_name, -> { includes(:user).order 'users.last_name', 'users.first_name' }

  validates :user,
            uniqueness: { scope: :organization_id },
            presence: true

  before_destroy :validate_references

  delegate :name, to: :user, prefix: true, allow_nil: true

  # super_user can CRUD over timeEntries (+ timeOffEntries/Periods) for ALL users in organization
  # this role exists only at the organization level.
  enum role: %i[user super_user admin]

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

  def awaiting_invitation?
    !user.confirmed? && user.invitation_token
  end

  private

  def validate_references
    return if destroyable?
    errors.add :base, 'is referenced by projects'
    throw :abort
  end
end

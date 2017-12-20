# frozen_string_literal: true

class ProjectMember < ApplicationRecord
  belongs_to :project, inverse_of: :members
  belongs_to :user, inverse_of: :project_memberships

  scope :by_user_name, -> { includes(:user).order 'users.last_name', 'users.first_name' }

  validate :validate_organization_references, on: :create

  delegate :email, :name, to: :user, prefix: true, allow_nil: true

  private

  def validate_organization_references
    return if user.nil? || project.nil? || user.membership_in(project.organization)
    errors.add :project, :forbidden
  end
end

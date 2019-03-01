# frozen_string_literal: true

# == Schema Information
#
# Table name: project_members
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_project_members_on_user_id_and_project_id  (user_id,project_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (user_id => users.id)
#


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

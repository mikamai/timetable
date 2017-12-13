# frozen_string_literal: true

class ProjectMember < ApplicationRecord
  belongs_to :project, inverse_of: :members
  belongs_to :user, inverse_of: :project_memberships

  scope :by_user_name, -> { includes(:user).order 'users.last_name', 'users.first_name' }

  delegate :name, to: :user, prefix: true
end

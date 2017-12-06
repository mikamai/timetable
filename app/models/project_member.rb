# frozen_string_literal: true

class ProjectMember < ApplicationRecord
  belongs_to :project, inverse_of: :members
  belongs_to :user, inverse_of: :project_memberships

  delegate :email, to: :user, prefix: true
end

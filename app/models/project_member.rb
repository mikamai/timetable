# frozen_string_literal: true

class ProjectMember < ApplicationRecord
  belongs_to :project, inverse_of: :members
  belongs_to :user

  delegate :email, to: :user, prefix: true
end

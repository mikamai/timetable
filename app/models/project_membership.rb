# frozen_string_literal: true

class ProjectMembership < ApplicationRecord
  belongs_to :project
  belongs_to :user
end

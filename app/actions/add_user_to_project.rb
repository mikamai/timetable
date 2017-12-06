# frozen_string_literal: true

class AddUserToProject
  class << self
    def perform *args
      new(*args).perform
    end
  end

  attr_reader :project, :user_email

  delegate :organization, to: :project

  def initialize project, user_email
    @project = project
    @user_email = user_email
  end

  def perform
    membership = project.project_memberships.build
    membership.user = organization.users.find_by email: user_email
    if membership.user
      membership.save
    else
      membership.errors.add :user, :not_found
    end
    membership
  end
end

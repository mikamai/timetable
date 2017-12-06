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
    project.members.build(user: user_by_email).tap do |member|
      if member.user
        member.save
      else
        member.errors.add :user, :not_found
      end
    end
  end

  def user_by_email
    organization.users.find_by email: user_email
  end
end

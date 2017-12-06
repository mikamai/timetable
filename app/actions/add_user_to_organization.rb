# frozen_string_literal: true

class AddUserToOrganization
  class << self
    def perform *args
      new(*args).perform
    end
  end

  attr_reader :organization, :user_email

  def initialize organization, user_email
    @organization = organization
    @user_email = user_email
  end

  def perform
    organization.members.build.tap do |member|
      member.user = User.find_by email: user_email
      if member.user
        member.save
      else
        member.errors.add :user, :not_found
      end
    end
  end
end

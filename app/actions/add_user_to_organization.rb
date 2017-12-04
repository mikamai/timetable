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
    membership = organization.organization_memberships.build
    membership.user = User.find_by email: user_email
    if membership.user
      membership.save
    else
      membership.errors.add :user, :not_found
    end
    membership
  end
end

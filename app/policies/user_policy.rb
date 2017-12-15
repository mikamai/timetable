class UserPolicy < ApplicationPolicy
  attr_reader :user, :resource

  def initialize user, resource
    @user = user
    @resource = resource
  end

  def index?
    @user.admin?
  end
end

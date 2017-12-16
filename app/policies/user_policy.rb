class UserPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def create?
    index?
  end
end

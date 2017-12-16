class ProjectPolicy < ApplicationPolicy
  def index?
    @user.admin_in? record.organization
  end

  def create?
    index?
  end

  def update?
    index?
  end

  def show?
    index?
  end
end

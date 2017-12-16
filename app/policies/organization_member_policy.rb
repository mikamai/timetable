class OrganizationMemberPolicy < ApplicationPolicy
  def index?
    @user.admin_in? record.organization
  end

  def create?
    index?
  end

  def show?
    index?
  end

  def destroy?
    index? && record.destroyable?
  end

  def toggle_admin?
    index?
  end
end

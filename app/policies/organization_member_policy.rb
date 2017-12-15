class OrganizationMemberPolicy < ApplicationPolicy
  attr_reader :user, :organization_member

  def initialize user, organization_member
    @user = user
    @organization_member = organization_member
  end

  def index?
    @user.admin_in? organization_member.organization
  end

  def create?
    index?
  end

  def show?
    index?
  end

  def destroy?
    index? && organization_member.destroyable?
  end

  def toggle_admin?
    index?
  end
end

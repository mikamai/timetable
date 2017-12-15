class ProjectPolicy < ApplicationPolicy
  attr_reader :user, :project

  def initialize user, project
    @user = user
    @project = project
  end

  def index?
    @user.admin_in? project.organization
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

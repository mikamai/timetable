# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize user, record
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize user, scope
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end

    def user_admin?
      return true if user.admin?
      organization_id = scope.where_values_hash['organization_id']
      organization_id && user.admin_in?(organization_id)
    end
  end
end

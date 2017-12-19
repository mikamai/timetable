# frozen_string_literal: true

module Organized
  class OrganizationMemberPolicy < BasePolicy
    def index?
      organization_membership.admin?
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
end

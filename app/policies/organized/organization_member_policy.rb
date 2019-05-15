# frozen_string_literal: true

module Organized
  class OrganizationMemberPolicy < BasePolicy
    def index?
      admin?
    end

    def create?
      index?
    end

    def show?
      index? && record_in_scope?
    end

    def destroy?
      show? && record.destroyable?
    end

    def update_role?
      show? && record.user != self.user
    end

    def resend_invitation?
      create? && record.awaiting_invitation?
    end
  end
end

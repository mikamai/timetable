# frozen_string_literal: true

module Organized
  class BasePolicy < ApplicationPolicy
    attr_reader :organization_membership

    def initialize organization_membership, record
      @organization_membership = organization_membership
      super organization_membership.user, record
    end

    def user
      organization_membership.user
    end

    def admin?
      organization_membership.admin? || user.admin?
    end

    def scope
      Pundit.policy_scope!(organization_membership, record.class)
    end

    class Scope < Scope
      attr_reader :organization_membership

      def initialize organization_membership, scope
        @organization_membership = organization_membership
        super organization_membership.user, scope
      end

      def admin?
        organization_membership.admin? || user.admin?
      end
    end
  end
end

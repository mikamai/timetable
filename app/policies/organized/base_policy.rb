# frozen_string_literal: true

module Organized
  class BasePolicy < ApplicationPolicy
    attr_reader :organization_membership

    delegate :user, to: :organization_membership

    def initialize organization_membership, record
      @organization_membership = organization_membership
      super organization_membership.user, record
    end

    def admin?
      organization_membership.admin?
    end

    def super_user?
      organization_membership.super_user?
    end

    def record_in_scope?
      return true if user.admin?
      if record.respond_to?(:organization) && record.organization.present?
        return organization_membership.organization == record.organization
      end
      true
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

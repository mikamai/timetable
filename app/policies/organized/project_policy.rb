# frozen_string_literal: true

module Organized
  class ProjectPolicy < BasePolicy
    def index?
      record_in_scope?
    end

    def create?
      admin?
    end

    def update?
      admin?
    end

    def destroy?
      admin?
    end

    def show?
      user.membership_in(record).present?
    end
  end
end

# frozen_string_literal: true

module Organized
  class ProjectPolicy < BasePolicy
    def index?
      admin?
    end

    def create?
      index?
    end

    def update?
      index? && record_in_scope?
    end

    def show?
      user.membership_in(record).present?
    end
  end
end

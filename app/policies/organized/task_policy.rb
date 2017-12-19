# frozen_string_literal: true

module Organized
  class TaskPolicy < BasePolicy
    def index?
      organization_membership.admin?
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
end

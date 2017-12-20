# frozen_string_literal: true

module Organized
  class TaskPolicy < BasePolicy
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
      update?
    end
  end
end

# frozen_string_literal: true

module Organized
  class ClientPolicy < BasePolicy
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

    def destroy?
      update? && record.destroyable?
    end
  end
end

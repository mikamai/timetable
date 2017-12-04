# frozen_string_literal: true

module Admin
  class BaseController < ApplicationController
    layout 'admin'

    before_action :authenticate_user!, :require_admin

    private

    def require_admin
      raise ActionController::RoutingError, 'Not Found' unless current_user.admin?
    end
  end
end

# frozen_string_literal: true

module Organized
  class HomeController < BaseController
    def show; end

    private

    def organization_param
      params[:id]
    end
  end
end

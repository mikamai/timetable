# frozen_string_literal: true

module Organized
  class HomeController < BaseController
    def show
      redirect_to [current_organization, TimeView.today(current_organization, current_user)]
    end

    private

    def organization_param
      params[:id]
    end
  end
end

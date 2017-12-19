# frozen_string_literal: true

module Admin
  class UsersController < BaseController
    def index
      @users = User.by_name.page params[:page]
      authorize User
      respond_with @users
    end
  end
end

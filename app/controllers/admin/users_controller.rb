module Admin
  class UsersController < BaseController
    def index
      @users = User.by_name.page params[:page]
      respond_with @users
    end
  end
end

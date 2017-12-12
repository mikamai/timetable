# frozen_string_literal: true

class ProfileController < ApplicationController
  before_action :authenticate_user!

  def edit; end

  def update
    current_user.update_with_password update_attributes
    respond_with current_user, location: -> { profile_path }
  end

  private

  def update_attributes
    params.require(:user).permit :first_name, :last_name, :email,
                                 :password, :password_confirmation,
                                 :current_password
  end
end

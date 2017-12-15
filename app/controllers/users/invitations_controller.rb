module Users
  class InvitationsController < Devise::InvitationsController
    def new
      authorize resource_class
      super
    end

    def create
      authorize resource_class
      super
    end

    private

    def after_invite_path_for inviter, resource
      admin_users_path
    end
  end
end

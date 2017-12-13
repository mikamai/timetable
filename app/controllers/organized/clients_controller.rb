# frozen_string_literal: true

module Organized
  class ClientsController < BaseController
    def index
      @clients = current_organization.clients.by_name.page params[:page]
      respond_with current_organization, @clients
    end

    def new
      @client = current_organization.clients.build
      respond_with current_organization, @client
    end

    def create
      @client = current_organization.clients.create create_params
      respond_with current_organization, @client
    end

    def edit
      @client = current_organization.clients.friendly.find params[:id]
      respond_with current_organization, @client
    end

    def update
      @client = current_organization.clients.friendly.find params[:id]
      @client.update_attributes update_params
      respond_with current_organization, @client
    end

    def destroy
      @client = current_organization.clients.friendly.find params[:id]
      @client.safe_destroy
      respond_with current_organization, @client
    end

    private

    def create_params
      params.require(:client).permit :name
    end

    def update_params
      params.require(:client).permit :slug, :name
    end
  end
end

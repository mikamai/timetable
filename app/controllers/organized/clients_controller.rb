# frozen_string_literal: true

module Organized
  class ClientsController < BaseController
    def index
      @clients = current_organization.clients.by_name.page params[:page]
      authorize Client
      respond_with current_organization, @clients
    end

    def new
      @client = current_organization.clients.build
      authorize @client
      respond_with current_organization, @client
    end

    def create
      @client = current_organization.clients.build client_params
      authorize @client
      @client.save
      respond_with current_organization, @client
    end

    def edit
      @client = current_organization.clients.friendly.find params[:id]
      authorize @client
      respond_with current_organization, @client
    end

    def update
      @client = current_organization.clients.friendly.find params[:id]
      authorize @client
      @client.update_attributes client_params
      respond_with current_organization, @client
    end

    def destroy
      @client = current_organization.clients.friendly.find params[:id]
      authorize @client
      @client.destroy
      respond_with current_organization, @client
    end

    private

    def client_params
      params.require(:client).permit :name
    end
  end
end

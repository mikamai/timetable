# frozen_string_literal: true

module Organized
  class ClientsController < BaseController
    respond_to :html, :json

    def index
      @clients = current_organization.clients.order('name')
      respond_with current_organization, @clients
    end

    def create
      @client = current_organization.clients.create client_params
      respond_with current_organization, @client
    end

    private

    def client_params
      params.require(:client).permit(:name)
    end
  end
end

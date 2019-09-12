# frozen_string_literal: true

module ApplicationHelper
  def set_public_key
    uri = URI('https://sso.mikamai.com/auth/realms/mikamai/protocol/openid-connect/certs')
    json_key = Net::HTTP.get uri
    JSON::JWK::Set.new(JSON.parse(json_key))
  end
end

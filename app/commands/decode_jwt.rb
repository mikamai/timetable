# frozen_string_literal: true

class DecodeJwt
  prepend SimpleCommand
  include ApplicationHelper

  def initialize token, public_key: nil
    @token = token
    @public_key = public_key || set_public_key
  end

  def call
    return errors.add(:credentials, 'are missing') unless @token.present?
    validate JSON::JWT.decode(@token, @public_key)
  rescue JSON::JWT::Exception => e
    errors.add :decoding, e.message
  end

  private

  def validate jwt
    errors.add(:expiration, 'is missing') unless jwt[:exp].present?
    errors.add(:sub, 'is missing') unless jwt[:sub].present?
    errors.add(:iat, 'is missing') unless jwt[:iat].present?
    return jwt if errors.any?

    errors.add(:expiration, 'is expired') if Time.at(jwt[:exp]) < Time.now
    errors.add(:iat, 'is more than 3 months ago') if Time.at(jwt[:iat]) < 3.months.ago
    jwt
  end
end
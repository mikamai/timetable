# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DecodeJwt do
  let(:claims) do
    {
      'iss' => 'https://sso.mikamai.com/auth/realms/mikamai',
      'aud' => 'account',
      'sub' => 'test',
      'exp' => 1.week.from_now.to_i,
      'iat' => Time.now.to_i
    }
  end
  let(:expired_claims) do
    claims['exp'] = 1.week.ago.to_i
    claims
  end

  let(:private_key) { OpenSSL::PKey::RSA.generate(2048) }
  let(:public_key) { private_key.public_key }

  let(:fake_key) { OpenSSL::PKey::RSA.generate(2048) }

  let(:valid_token) { JSON::JWT.new(claims).sign(JSON::JWK.new(private_key), :RS256).to_s }
  let(:expired_token) { JSON::JWT.new(expired_claims).sign(JSON::JWK.new(private_key), :RS256).to_s }
  let(:invalid_token) { JSON::JWT.new(claims).sign(JSON::JWK.new(fake_key), :RS256).to_s }

  it 'decodes a valid JWT' do
    cmd = DecodeJwt.call valid_token, public_key: public_key
    expect(cmd.success?).to be_truthy
    expect(cmd.result).to eq(claims)
  end

  it 'fails on an invalid JWT' do
    cmd = DecodeJwt.call invalid_token, public_key: public_key
    expect(cmd.errors[:decoding].count).to eq 1
  end

  it 'fails on an expired JWT' do
    cmd = DecodeJwt.call expired_token, public_key: public_key
    expect(cmd.errors[:expiration].count).to eq 1
  end
end
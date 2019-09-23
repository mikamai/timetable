# frozen_string_literal: true
module TestsHelpers

  def generate_tokens user
    private_key = generate_key
    fake_key = generate_key

    {
      public_key: private_key.public_key,
      valid_token: generate_token(claims(user), private_key),
      no_user_token: generate_token(no_user_claims, private_key),
      expired_token: generate_token(expired_claims(user), private_key),
      invalid_token: generate_token(claims(user), fake_key),
    }
  end

  def set_token token
    header = {"Authorization": "Bearer #{token}", "Accept": "application/json"}
    request.headers.merge!(header)
  end

  def set_organization_role user, organization, role
    membership = user.membership_in organization
    membership.role = role
    membership if membership.save
  end

  def verify_expectation_for action, user, project
    case action
    when "index"
      expect(parse_response["data"].map{ |entry| entry["user_id"] == user.id }.include?(false)).to eq false
    when "index_project"
      expect(parse_response["data"].map{ |entry| entry["user_id"] == user.id && entry["project_id"] == project.id }.include?(false)).to eq false
    when "create"
      expect(parse_response["id"]).not_to be_nil
      expect(parse_response["amount"]).to eq 120
    when "update"
      expect(parse_response["id"]).to eq time_entry.id
      expect(parse_response["notes"]).to eq "Updated"
    when "destroy"
      expect(response.body).to eq("{}")
    end
  end

  private

  def generate_token claim, key
    JSON::JWT.new(claim).sign(JSON::JWK.new(key), :RS256).to_s
  end

  def generate_key
    OpenSSL::PKey::RSA.generate(2048)
  end

  def parse_response
    JSON.parse(response.body)
  end

  def base_claims
    {
      'iss' => 'https://sso.mikamai.com/auth/realms/mikamai',
      'aud' => 'account',
      'sub' => 'test',
      'iat' => Time.now.to_i,
    }
  end

  def claims user
    base_claims.merge({
      'exp' => 1.week.from_now.to_i,
      'email' => user.email,
      'preferred_username' => user.first_name,
    })
  end

  def expired_claims user
    base_claims.merge({
      'exp' => 1.week.ago.to_i,
      'email' => user.email,
      'preferred_username' => user.first_name,
    })
  end

  def no_user_claims
    base_claims.merge({
      'exp' => 1.week.from_now.to_i,
      'email' => 'not_existing@gmail.com',
      'preferred_username' => 'not_existing',
    })
  end
end

RSpec.configure do |config|
  config.include TestsHelpers
end

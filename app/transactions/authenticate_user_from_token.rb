# frozen_string_literal: true

class AuthenticateUserFromToken
  include Dry::Transaction

  step :jwt
  step :user_from_token

  def jwt input
    cmd = DecodeJwt.call input[:authorization_header], public_key: input[:public_key]
    return Failure(status: :unauthorized, message: cmd.errors) unless cmd.success?

    input[:jwt] = cmd.result
    Success(input)
  end

  def user_from_token input
    jwt = input[:jwt]
    api_user = User.where(email: jwt[:email]).first_or_create do |new_user|
      new_user.email = jwt[:email]
      new_user.first_name = jwt[:given_name] || jwt[:preferred_username]
      new_user.last_name = jwt[:family_name] || jwt[:preferred_username]
      password = Devise.friendly_token[0, 20]
      new_user.password = password
      new_user.password_confirmation = password
      new_user.skip_confirmation!
    end
    # should not happen: means that token is valid, was decoded but for some reason user was not created.
    Rollbar.log("error", "Crashed while first_or_create user from token.")
    return Failure(status: 500, message: "Oops, something went wrong") unless api_user.present?

    Success(api_user)
  end
end
class AuthenticationsController < ApplicationController
  skip_before_action :authenticate_request

  def authenticate
    authenticator = AuthenticateUser.new(email: params[:email], password: params[:password])
    authenticator.call

    if authenticator.success?
      render json: { auth_token: authenticator.authentication_token }
    else
      render json: { error: authenticator.errors }, status: :unauthorized
    end
  end
end

class Api::V1::AuthController < ApplicationController
  skip_before_action :authorize_request, only: [:login]

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = encode_token(user_id: user.id)

      render json: {
        user: {
          id: user.id,
          email: user.email
        },
        token: token
      }, status: :ok
    else
      render json: {
        error: 'Invalid email or password'
      }, status: :unauthorized
    end
  end
end

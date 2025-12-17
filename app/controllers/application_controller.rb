class ApplicationController < ActionController::API
  before_action :authorize_request

  def encode_token(payload)
    JWT.encode(payload, Rails.application.secret_key_base)
  end

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ').last
      begin
        JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def current_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @current_user ||= User.find_by(id: user_id)
    end
  end

  def logged_in?
    !!current_user
  end

  def authorize_request
    render json: { message: 'A token is required for authentication!' }, status: :unauthorized unless logged_in?
  end
end

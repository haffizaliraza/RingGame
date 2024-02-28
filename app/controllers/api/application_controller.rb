class Api::ApplicationController < ActionController::API
  before_action :set_default_format
  before_action :authenticate_user!

  protected

  def set_default_format
    request.format = :json
  end

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last

    unless token && valid_token?(token)
      render json: { error: 'Unauthorized - Token missing or invalid' }, status: :unauthorized
    end
  end

  def valid_token?(token)
    begin
      decoded_token = JsonWebToken.decode(token)
      user_id = decoded_token['user_id']
      user = User.find_by(id: user_id)
      sign_in user if current_user != user_id
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      false
    end
  end
end

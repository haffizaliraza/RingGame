class Api::AuthenticationController < Api::ApplicationController
  skip_before_action :authenticate_user!, only: [:create]

  def create
    user = User.find_by(email: params[:user][:email])
    if user.valid_password? params[:user][:password]
      render json: { token: JsonWebToken.encode(user_id: user.id) }
    else
      render json: { errors: ["Invalid email or password"] }
    end
  end

  def destroy
    session.delete(current_user.id)
    sign_out(current_user)
    render json: { :message => 'Sign out Successfully.' }, status: 200
  end
end

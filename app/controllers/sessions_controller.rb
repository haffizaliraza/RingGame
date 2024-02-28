# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  before_action :set_user, only: %i[create]

  # POST /resource/sign_in
  def create
    if @user.present? && (@user.team_id.nil? || @user.is_team_admin)
      super
    else
      redirect_to new_user_session_path
    end
  end

  private

  def set_user
    @user = User.find_by(email: params[:user][:email])
  end
end

# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[edits update]

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to authenticated_root_path, notice: 'Profile updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :avatar, :password, :password_confirmation)
  end
end

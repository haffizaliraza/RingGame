# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[edit destroy_avatar update]

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to authenticated_root_path, notice: 'Profile updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy_avatar
    @user.avatar.purge

    redirect_to edit_user_path
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:first_name, :gender, :last_name, :email, :avatar, :country, :state, :city, :password, :password_confirmation)
  end
end

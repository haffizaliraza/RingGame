# frozen_string_literal: true

class TeamsController < ApplicationController
  before_action :set_team, only: %i[ add_player create_player ]

  def add_player
    @user = @team.users.build
  end

  def create_player
    user = @team.users.new(player_params)
    if user.save
      redirect_to authenticated_root_path, notice: 'Player Added Successfully!'
    else
      render :add_player, alert: 'Something went wrong!'
    end
  end

  def create
    user = User.new(user_params)
    team = Team.new(team_params)

    ActiveRecord::Base.transaction do
      unless user.save && team.save
        raise ActiveRecord::Rollback
      end

      user.update(team_id: team.id, is_team_admin: true)
      sign_in user
      redirect_to authenticated_root_path, notice: 'Team Created Successfully!'
    end

  rescue ActiveRecord::RecordInvalid => e
      flash.now[:alert] = "Failed to create team: #{e.message}"
  end

  private

  def set_team
    @team = current_user.team if current_user.team_id.eql?(params[:id].to_i)

    return redirect_to root_path if @team.nil?
  end

  def team_params
    params.require(:team).permit(:name, :avatar)
  end

  def user_params
    params.require(:team).require(:user).permit(
      :first_name, :last_name, :email, :avatar, :country, :state, :city,
      :password, :password_confirmation, :gender
    )
  end

  def player_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :avatar, :country, :state, :city,
      :password, :password_confirmation, :gender, :is_team_admin
    )
  end
end
  
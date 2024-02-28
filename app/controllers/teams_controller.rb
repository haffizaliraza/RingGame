# frozen_string_literal: true

class TeamsController < ApplicationController
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
  
    def team_params
      params.require(:team).permit(:name, :avatar)
    end
  
    def user_params
      params.require(:team).require(:user).permit(
        :first_name, :last_name, :email, :avatar, :country, :state, :city,
        :password, :password_confirmation, :gender
      )
    end
  end
  
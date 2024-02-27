Rails.application.load_tasks

class Game < ApplicationRecord
  belongs_to :user
  belongs_to :team, optional: true
  enum status: [:initiated, :in_progress, :completed, :hold]
  has_many :shorts

  validate :user_can_create_game, on: :create

  after_save :update_rankings

  def self.filter(params)
    scope = all
    return scope if params[:type] == 'all'
  
    scope = scope.where.not(team_id: nil) if params[:type] == 'team'
  
    if params[:type] == 'user'
      scope = scope.where(team_id: nil)
      return scope if params[:gender] == 'all'

      scope = scope.joins(:user).where(users: { gender: params[:gender] })
    end

    scope
  end
  


  def calculate_score
    return 0 if shorts.empty?

    successful_shots = shorts.where(result: true).count
    total_shots = shorts.count

    (successful_shots.to_f / total_shots) * 100
  end

  private

  def update_rankings
    if self.status == 'completed'
      Rake::Task['rankings:update'].invoke
    end
  end

  def user_can_create_game
    existing_games = user.games.where(status: [:initiated, :in_progress])
    existing_team_games = user.team&.games&.where(status: [:initiated, :in_progress])

    if existing_games&.exists? || existing_team_games&.exists?
      errors.add(:base, "User already has a game in progress or initiated.")
    end
  end
end

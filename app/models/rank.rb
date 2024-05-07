class Rank < ApplicationRecord
  GAME_WEIGHT = 0.7
  SCORE_WEIGHT = 0.3

  belongs_to :user
  belongs_to :team, optional: true

  validates :user_id, uniqueness: true

  def self.sorted
    select('ranks.*, COUNT(games.id) AS games_count')
      .joins(:user)
      .joins('LEFT JOIN games ON games.user_id = users.id')
      .group('ranks.id')
      .order('games_count DESC, success_rate DESC')
  end
end
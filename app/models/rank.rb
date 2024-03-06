class Rank < ApplicationRecord
  belongs_to :user
  belongs_to :team, optional: true

  def self.sorted
    select('ranks.*, COUNT(games.id) AS games_count')
      .joins(:user)
      .joins('LEFT JOIN games ON games.user_id = users.id')
      .group('ranks.id')
      .order('games_count DESC, success_rate DESC')
  end
end
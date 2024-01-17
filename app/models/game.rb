class Game < ApplicationRecord
  belongs_to :user
  enum status: [:initiated, :in_progress, :completed, :hold]
  has_many :shorts

  after_update_commit do
    self.broadcast_replace_to(
      self,
      target: "game_#{self.id}",
      partial: "games/game",
      locals: {
        game: self
      }
    )
  end

  validate :user_can_create_game, on: :create

  private

  def user_can_create_game
    existing_games = user.games.where(status: [:initiated, :in_progress])

    if existing_games.exists?
      errors.add(:base, "User already has a game in progress or initiated.")
    end
  end
end

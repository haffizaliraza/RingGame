class Short < ApplicationRecord
  belongs_to :game

  after_create_commit do
    self.game.broadcast_update_to(
      self.game,
      target: "game_#{self.game_id}",
      partial: "games/game",
      locals: {
        game: self.game
      }
    )
  end

  validate :validate_short_limit, on: :create

  private

  def validate_short_limit
    return true if game.nil?

    if game.shorts.count >= game.no_of_shots
      errors.add(:base, "Cannot create more shorts. Limit reached.")
    end
  end
end

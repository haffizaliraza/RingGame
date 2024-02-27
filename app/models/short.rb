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
  after_save :update_game_status

  private

  def update_game_status
    if game.shorts.where(result: false).count >= game.no_of_shots
      game.update(status: :completed)
    elsif game.shorts.count == 1
      game.update(status: :in_progress)
    end
  end

  def validate_short_limit
    return true if game.nil?

    if game.shorts.where(result: false).count >= game.no_of_shots
      errors.add(:base, "Cannot create more shorts. Limit reached.")
    end
  end
end

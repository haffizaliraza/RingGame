class Game < ApplicationRecord
  belongs_to :user
  enum status: [:initiated, :in_progress, :completed, :hold]
  has_many :shorts
end

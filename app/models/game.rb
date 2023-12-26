class Game < ApplicationRecord
  belongs_to :user
  enum status: [:initiated, :in_progress, :completed]
  has_many :shorts
end

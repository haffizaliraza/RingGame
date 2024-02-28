class User < ApplicationRecord
  has_many :games
  belongs_to :team, optional: true
  has_many :male_ranks
  has_many :female_ranks

  GENDER = { male: 0, female: 1 }.freeze
  enum gender: GENDER

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar


  def current_success_rate
    score = 0
    games.each do |game|
      score += game.calculate_score
    end
    return score if score < 1

    (score / games.count).round(2)
  end
end

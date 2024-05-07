class User < ApplicationRecord
  has_many :games
  belongs_to :team, optional: true
  has_many :ranks

  GENDER = { male: 0, female: 1 }.freeze
  enum gender: GENDER

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar


  def current_success_rate
    ranks.last.success_rate
  end

  def current_max_streak
    streak_list = []
    games.each do |game|
      streak_list << max_streak(game)
    end
    streak_list.max
  end

  private

  def max_streak(game)
    current_streak = 0
    success_streaks = []
    game.shorts.order(created_at: :asc).each do |short|
      if short.result == true
        current_streak += 1
      else
        success_streaks << current_streak if current_streak.positive?
        current_streak = 0
      end
    end

    success_streaks << current_streak if current_streak.positive?
    max_value = success_streaks.compact.max
    return 0 if max_value.nil?

    max_value
  end
end

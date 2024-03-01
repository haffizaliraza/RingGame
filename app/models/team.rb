class Team < ApplicationRecord
    has_many :users
    has_one_attached :avatar
    has_many :games
    has_many :ranks


    def current_success_rate
        score = 0.0
        games.each do |game| 
            score += game.calculate_score
        end
        return score if score < 1

        (score / games.count).round(2)
    end
end
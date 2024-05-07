class Team < ApplicationRecord
    has_many :users
    has_one_attached :avatar
    has_many :games
    has_many :ranks


    def current_success_rate
        ranks.last.success_rate
    end
end
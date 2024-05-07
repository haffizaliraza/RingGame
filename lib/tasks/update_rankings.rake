namespace :rankings do
  desc 'Update user and team rankings'
  task update: :environment do
    class Player
      attr_accessor :name, :scores, :games_played
      
      def initialize(name, scores, games_played)
        @name = name
        @scores = scores
        @games_played = games_played
      end
      
      def average_score
        @scores.sum / @scores.size.to_f
      end
    end

    def rank_players(players_data)
      weighted_scores = []
      players_data.each do |player|
        score_weight = Rank::SCORE_WEIGHT
        games_weight = Rank::GAME_WEIGHT

        weighted_score = (player.average_score * score_weight) + (player.games_played * games_weight)

        weighted_scores << [player.name, weighted_score, player.average_score, player.games_played]
      end

      ranked_players = weighted_scores.sort_by { |_, score| score }.reverse
      
      ranked_players
    end

    player_data_all = []
    User.all.each do |user|
      player_data_all << {"name": user.id,"games": user.games.map {|game| game.short_true },"total": user.games.count}
    end

    players_data = []
    player_data_all.each do |data|
      players_data << Player.new(data[:name], data[:games], data[:total])
    end

    ranked_players = rank_players(players_data)

    # Output ranked players
    ranked_players.each_with_index do |(name, score), index|

      success_rate = score.round(2)
      user =  User.find_by(id: name)
      rank = nil
      if user.is_team_admin
        rank = Rank.find_or_initialize_by(user_id: name, team_id: user.team.id)
      else
        rank = Rank.find_or_initialize_by(user_id: name)
      end
      rank.max_streak =  user.current_max_streak
      rank.success_rate = success_rate
      rank.save
    end
  end
end

module DashboardHelper

  def total_games
    Game.all.count
  end

  def in_progress_games
    Game.where(status: :in_progress).count
  end

  def completed_games
    Game.where(status: :completed).count
  end

  def total_teams
    Team.all.count
  end

  def total_users
    User.all.count
  end

  def team_list
    list = []
    Team.all.each do |team|
      list << [team.name, team.id]
    end
    list
  end

  def user_list
    list = []
    User.all.each do |user|
      next if user.team.present?
      name = user.first_name ? "#{user.first_name} #{user.last_name}" : '-'
      list << [name, user.id]
    end
    list
  end

  def game_player_name(games)
    games.last.present? ? game_player(games.last) : '-'
  end

  def game_player(game)
    game.user.present? ? "#{game.user.first_name} #{game.user.last_name}" : game.team.name
  end

  def calculate_success_rates(games)
    success_rates = {}
    games.each do |game|
      total_shots = game.shorts.count
      successful_shots = game.shorts.where(result: true).count
      success_rate = total_shots > 0 ? ((successful_shots.to_f / total_shots) * 100).round(2) : nil
      success_rates[game.created_at] = success_rate
    end
    success_rates
  end
end

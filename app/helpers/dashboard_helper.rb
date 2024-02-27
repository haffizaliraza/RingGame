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
end

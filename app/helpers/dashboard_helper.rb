module DashboardHelper
  def total_games
    Game.count
  end

  def in_progress_games
    Game.where(status: :in_progress).count
  end

  def completed_games
    Game.where(status: :completed).count
  end

  def total_teams
    Team.count
  end

  def total_users
    User.count
  end

  def team_list
    Team.pluck(:name, :id)
  end

  def user_list(gender)
    User.where(gender: gender).pluck(Arel.sql("CONCAT(first_name, ' ', last_name)"), :id)
  end  

  def state_list
    User.where.not(state: '').distinct.pluck(:state, :state).map { |state| [state[0].humanize, state[1]] }
  end

  def country_list
    User.where.not(country: '').distinct.pluck(:country, :country).map { |country| [country[0].humanize, country[1]] }
  end

  def game_player_name(games)
    games.last&.player_name || '-'
  end

  def calculate_success_rates(games)
    return {} unless games.present?

    games.each_with_object({}) do |game, success_rates|
      total_shots = game.shorts.count
      successful_shots = game.shorts.where(result: true).count
      success_rate = total_shots.positive? ? ((successful_shots.to_f / total_shots) * 100).round(2) : nil
      success_rates[game.created_at] = success_rate
    end
  end

  def total_ranks
    Rank.sorted
  end

  def total_team_ranks
    Rank.joins(:user).where(users: { is_team_admin: true }).sorted
  end

  def total_male_ranks
    Rank.joins(:user).where(users: { gender: 'male' }).sorted
  end

  def total_female_ranks
    Rank.joins(:user).where(users: { gender: 'female' }).sorted
  end

  def calculate_ranks(ranks)
    return {} unless ranks.present?

    ranks.each_with_object({}) do |rank, success_rates|
      username = rank.user.is_team_admin ? rank.team.name : rank.user.first_name + rank.user.last_name
      success_rates[username] = rank.success_rate
    end
  end

  def team_players
    current_user.team.users.where.not(id: current_user.id)
  end

  def player_max_streak(games)
    streak_list = []
    games.each do |game|
      streak_list << max_streak(game)
    end
    streak_list.max
  end

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

    success_streaks.max
  end

  def team_stats(users)
    max_team_streak = []
    users.each do |user|
      if user.games.length > 0
        max_team_streak << player_max_streak(user.games)
      else
        0
      end
    end
    max_team_streak.max
  end

  def team_games(users)
    max_games = 0
    users.each do |user|
      max_games += user.games.count
    end
    max_games
  end

  def team_success_rate(users)
    success_rate = 0.0
    users.each do |user|
      success_rate += user.current_success_rate
    end
    (success_rate).round(2)
  end
end

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
    games.each_with_object({}) do |game, success_rates|
      total_shots = game.shorts.count
      successful_shots = game.shorts.where(result: true).count
      success_rate = total_shots.positive? ? ((successful_shots.to_f / total_shots) * 100).round(2) : nil
      success_rates[game.created_at] = success_rate
    end
  end

  def total_ranks
    Rank.order(success_rate: :desc)
  end

  def total_team_ranks
    Rank.joins(:user).where(users: { is_team_admin: true }).order(success_rate: :desc)
  end

  def total_male_ranks
    Rank.joins(:user).where(users: { gender: 'male' }).order(success_rate: :desc)
  end

  def total_female_ranks
    Rank.joins(:user).where(users: { gender: 'female' }).order(success_rate: :desc)
  end

  def calculate_ranks(ranks)
    ranks.each_with_object({}) do |rank, success_rates|
      username = rank.user.is_team_admin ? rank.team.name : rank.user.first_name + rank.user.last_name
      success_rates[username] = rank.success_rate
    end
  end
end

states = ["State A", "State B", "State C", "State D", "State E"]
countries = ["Country X", "Country Y", "Country Z"]
# Create teams
teams = []
5.times do |i|
  teams << Team.create(name: Faker::Team.name)
end

# Create 20 users
20.times do |i|
  state = states.sample
  country = countries.sample

  user = User.create(
    email: Faker::Internet.email,
    password: "password",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    city: Faker::Address.city,
    state: Faker::Address.state,
    country: Faker::Address.country,
    is_team_admin: false,
    gender: Faker::Gender.binary_type == 'Male' ? 0 : 1
  )

  # Assign users to teams (if applicable)
  if i < teams.length
    user.update(team: teams[i], is_team_admin: true)
  end

  if i > teams.length && i < 5
    user.update(team: teams[i], is_team_admin: false)
  end
end

# Create games for each user
User.where(team_id: nil).each_with_index do |user, index|
  game_count = rand(1..9)
  (game_count * index + 1).times do |i|
    current_time = Time.now
    random_seconds = rand(0..15778463)
    random_time_in_past_six_months = current_time - random_seconds

    no_of_shots = (rand(2..5) * index + 1)

    game = Game.create(
      user: user,
      team: user.team,
      no_of_shots: no_of_shots,
      game_name: "Game #{i+1}",
      status: 'initiated',
      created_at: random_time_in_past_six_months
    )

    true_shorts = (rand(2..5) * index + 1)
    true_shorts.times do
      game.shorts.build(result: true)
    end

    # Seed shorts for each game
    no_of_shots.times do
      game.shorts.build(result: false)
    end

    game.status = 'completed'
    game.save!
  end
end

# Create games for each team
User.where.not(team_id: nil).each_with_index do |user, index|
  game_count = rand(1..9)
  (game_count * index + 1).times do |i|
    current_time = Time.now
    random_seconds = rand(0..15778463)
    random_time_in_past_six_months = current_time - random_seconds

    no_of_shots = (rand(2..5) * index + 1)

    game = Game.create(
      user: user,
      team: user.team,
      no_of_shots: no_of_shots,
      game_name: "Game #{i+1}",
      status: 'initiated',
      created_at: random_time_in_past_six_months
    )

    true_shorts = (rand(2..5) * index + 1)
    true_shorts.times do
      game.shorts.build(result: true)
    end

    # Seed shorts for each game
    no_of_shots.times do
      game.shorts.build(result: false)
    end

    game.status = 'completed'
    game.save!
  end
end


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
  
  # Normalize data and calculate weighted score
  players_data.each do |player|
    # Define weights
    score_weight = Rank::SCORE_WEIGHT
    games_weight = Rank::GAME_WEIGHT

    # Calculate weighted score
    weighted_score = (player.average_score * score_weight) + (player.games_played * games_weight)

    weighted_scores << [player.name, weighted_score, player.average_score, player.games_played]
  end
  
  # Sort players based on their weighted score
  ranked_players = weighted_scores.sort_by { |_, score| score }.reverse
  
  ranked_players
end

#generate data
player_data_all = []
User.all.each do |user|
  player_data_all << {"name": user.id, "games": user.games.map {|game| game.short_true }, "total": user.games.count}
end

# Input data
players_data = []
player_data_all.each do |data|
  players_data << Player.new(data[:name], data[:games], data[:total])
end


# Ranking players
ranked_players = rank_players(players_data)

# Output ranked players
ranked_players.each_with_index do |(name, score, average_score, games_played), index|

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
  puts "#{index + 1}. #{name}: #{score * 100}: #{user.current_max_streak}, #{games_played}:"
end
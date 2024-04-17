states = ["State A", "State B", "State C", "State D", "State E"]
countries = ["Country X", "Country Y", "Country Z"]
# Create teams
teams = []
10.times do |i|
  teams << Team.create(name: Faker::Team.name)
end

# Create 30 users
50.times do |i|
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

  if i > teams.length && i < 30
    user.update(team: teams[i], is_team_admin: false)
  end
end

# Create games for each user
User.where(team_id: nil).each_with_index do |user, index|
  game_count = rand(10..20)
  game_count.times do |i|
    current_time = Time.now
    random_seconds = rand(0..15778463)
    random_time_in_past_six_months = current_time - random_seconds

    # Generate a random number of shots for each game
    no_of_shots = rand(2..10)

    game = Game.create(
      user: user,
      no_of_shots: no_of_shots,
      game_name: "Game #{i+1}",
      status: 'initiated',
      created_at: random_time_in_past_six_months
    )

    true_shorts = rand(2..15)
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
  game_count = rand(10..20)
  game_count.times do |i|
    current_time = Time.now
    random_seconds = rand(0..15778463)
    random_time_in_past_six_months = current_time - random_seconds

    # Generate a random number of shots for each game
    no_of_shots = rand(2..10)

    game = Game.create(
      user: user,
      team: user.team,
      no_of_shots: no_of_shots,
      game_name: "Game #{i+1}",
      status: 'initiated',
      created_at: random_time_in_past_six_months
    )

    true_shorts = rand(2..15)
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

User.all.each do |user|
  next if user.games.length < 1 && user.team.blank?
  user_rank = {}
  if user.is_team_admin || user.team.present?
    user_rank = Rank.find_or_initialize_by(user_id: user.id, team_id: user.team.id)
  else
    user_rank = Rank.find_or_initialize_by(user_id: user.id)
  end
  success_rate = user.current_success_rate
  user_rank.success_rate = success_rate
  user_rank.max_streak = user.current_max_streak
  user_rank.save
end

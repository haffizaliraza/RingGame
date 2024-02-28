# Create teams
teams = []
10.times do |i|
  teams << Team.create(name: "Team #{i+1}")
end

# Create 20 users
30.times do |i|
  user = User.create(
    email: "user_#{i+1}@example.com",
    password: "password",
    first_name: "User",
    last_name: "#{i+1}",
    city: "City",
    state: "State",
    country: "Country",
    is_team_admin: false,
    gender: i.even? ? 0 : 1
  )

  # Assign users to teams (if applicable)
  if i < teams.length
    user.update(team: teams[i], is_team_admin: true)
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

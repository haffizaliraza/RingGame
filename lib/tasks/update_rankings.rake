namespace :rankings do
  desc 'Update user and team rankings'
  task update: :environment do
    Team.all.each do |team|
      next if team.games.length < 1
      team_rank = TeamRank.find_or_initialize_by(team_id: team.id)
      success_rate = team.current_success_rate
      team_rank.success_rate = success_rate
      team_rank.save
    end

    User.where(team_id: nil).each do |user|
      next if user.games.length < 1
      if user.gender == 'male'
        user_rank = MaleRank.find_or_initialize_by(user_id: user.id)
        success_rate = user.current_success_rate
        user_rank.success_rate = success_rate
        user_rank.save
      else
        user_rank = FemaleRank.find_or_initialize_by(user_id: user.id)
        success_rate = user.current_success_rate
        user_rank.success_rate = success_rate
        user_rank.save
      end
    end
  end
end

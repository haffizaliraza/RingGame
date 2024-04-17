namespace :rankings do
  desc 'Update user and team rankings'
  task update: :environment do
    User.all.each do |user|
      next if user.games.length < 1 && user.team.blank?
      user_rank = {}
      if user.is_team_admin || user.team.present?
        user_rank = Rank.find_or_initialize_by(user_id: user.id, team_id: user.team.id)
      else
        user_rank = Rank.find_or_initialize_by(user_id: user.id)
      end
      user_rank.success_rate = user.current_success_rate
      user_rank.max_streak = user.current_max_streak
      user_rank.save
    end
  end
end

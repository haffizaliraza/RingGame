module ApplicationHelper

  def player_name(rank)
    if rank.team.present?
      rank.team.name 
    else
      user_name(rank.user)
    end
  end

  def user_name(user)
    user.first_name ? "#{user.first_name} #{user.last_name}" : '-'
  end
end

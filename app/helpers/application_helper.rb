module ApplicationHelper

  def player_name(rank)
    if rank.class.to_s == 'TeamRank' || rank.class.to_s == 'OverallRank'
      rank.team_id.present? ? rank.team.name : user_name(rank.user)
    else
      user_name(rank.user)
    end
  end

  def user_name(user)
    user.first_name ? "#{user.first_name} #{user.last_name}" : '-'
  end
end

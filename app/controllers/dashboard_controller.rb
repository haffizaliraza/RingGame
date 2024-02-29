class DashboardController < ApplicationController
  before_action :authenticate_user!, only: :index

  def index
    fetch_game_stats if current_user.games.present?
  end

  def compare
    params[:user_1].present? ? user_comparison : params[:team_1].present? ? team_comparison : nil
  end

  def public
    case params[:type]
    when 'male' then display_ranks(MaleRank)
    when 'female' then display_ranks(FemaleRank)
    else display_ranks(TeamRank)
    end
  end

  private

  def team_comparison
    @records1, @records2 = fetch_comparison_records(Team, params[:team_1], params[:team_2])
    @records1, @records2 = @records1.users.first, @records2.users.first
  end

  def user_comparison
    @records1, @records2 = fetch_comparison_records(User, params[:user_1], params[:user_2])
  end

  def fetch_comparison_records(model, id1, id2)
    entity1 = model.find(id1)
    entity2 = model.find(id2)
    [entity1, entity2]
  end

  def display_ranks(rank_model)
    @ranks = rank_model.page(params[:page]).order(success_rate: :desc)
  end

  def fetch_game_stats
    @games = Game.where(user_id: current_user.id).page(params[:page]).includes(:shorts)
    @shorts = @games.flat_map(&:shorts)

    calculate_success_rates
  end

  def calculate_success_rates
    total_shorts_count = @shorts.count
    return if total_shorts_count.zero?

    @success_rate = calculate_rate(@shorts)
  end

  def calculate_rate(shorts)
    rate = (shorts.select(&:result).count.to_f / shorts.count) * 100
    rate.round(2)
  end
end


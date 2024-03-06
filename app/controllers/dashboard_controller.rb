class DashboardController < ApplicationController
  before_action :authenticate_user!, only: :index

  def index
    fetch_game_stats if current_user.games.present?
  end

  def compare
    case
    when params[:user_1].present? then user_comparison
    when params[:team_1] then team_comparison
    when params[:country_1] then country_comparison
    when params[:state_1] then state_comparison
    else
      @records1, @records2 = [[], []]
    end
  end

  def public
    display_ranks(Rank)
  end

  private

  def team_comparison
    fetch_comparison_records(Team, params[:team_1], params[:team_2])
  end

  def user_comparison
    fetch_comparison_records(User, params[:user_1], params[:user_2])
  end

  def country_comparison
    fetch_records(User, params[:country_1], params[:country_2], 'country')
  end

  def state_comparison
    fetch_records(User, params[:state_1], params[:state_2], 'state')
  end

  def fetch_records(model, column1, column2, column_name)
    entities = [model.where(column_name.to_sym => column1),
                model.where(column_name.to_sym => column2)]
    fetch_comparison_ranks(entities)
  end

  def fetch_comparison_records(model, id1, id2)
    if model.to_s == 'Team'
      entities = [model.find(id1).users, model.find(id2).users]
    else
      entities = [model.find(id1), model.find(id2)]
    end
    fetch_comparison_ranks(entities)
  end

  def fetch_comparison_ranks(entities)
    @records1, @records2 = entities
    record_ids1 = @records1.class.to_s == 'User' ? @records1 : @records1.pluck(:id)
    record_ids2 = @records2.class.to_s == 'User' ? @records2 : @records2.pluck(:id)
    @ranks1 = Rank.sorted.where(user_id: record_ids1).last(10)
    @ranks2 = Rank.sorted.where(user_id: record_ids2).last(10)
  end

  def display_ranks(rank_model)
    @ranks = rank_model.sorted.page(params[:page])
  end

  def fetch_game_stats
    @games = Game.where(user_id: current_user.id).order(created_at: :desc).page(params[:page]).includes(:shorts)
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

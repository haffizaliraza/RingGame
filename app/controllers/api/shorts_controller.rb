class Api::ShortsController < Api::ApplicationController
  before_action :authenticate_user!
  before_action :find_game, only: :create

  def create
    @short = @game.shorts.create(short_params)
    if @short.valid?
      render json: { message: 'Short Created Successfully!' }, status: 200
    else
      render json: { error: @short.errors }
    end

  end

  private

  def find_game
    @game = current_user.games.last
  end

  def short_params
    params.require(:short).permit(:result)
  end
end

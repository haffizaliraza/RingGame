class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    # Your dashboard logic goes here
  end
end

class ShortsController < ApplicationController
  before_action :set_short, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /shorts or /shorts.json
  def index
    @shorts = Short.all
  end

  # GET /shorts/1 or /shorts/1.json
  def show
  end

  # GET /shorts/new
  def new
    @short = Short.new
  end

  # GET /shorts/1/edit
  def edit
  end

  # POST /shorts or /shorts.json
  def create
    @short = Short.new(short_params)

    respond_to do |format|
      if @short.save
        format.html { redirect_to short_url(@short), notice: "Short was successfully created." }
        format.json { render :show, status: :created, location: @short }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @short.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shorts/1 or /shorts/1.json
  def update
    respond_to do |format|
      if @short.update(short_params)
        format.html { redirect_to short_url(@short), notice: "Short was successfully updated." }
        format.json { render :show, status: :ok, location: @short }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @short.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shorts/1 or /shorts/1.json
  def destroy
    @short.destroy

    respond_to do |format|
      format.html { redirect_to shorts_url, notice: "Short was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_short
      @short = Short.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def short_params
      params.require(:short).permit(:game_id, :result)
    end
end

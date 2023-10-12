class LikesController < ApplicationController
  before_action :set_like, only: %i[ show edit update destroy ]

  before_action :ensure_current_user_is_owner, only: [:destroy, :create]

  # GET /likes or /likes.json
  def index
    @likes = Like.all
  end

  # GET /likes/1 or /likes/1.json
  def show
    format.js
  end

  # GET /likes/new
  def new
    @like = Like.new
  end

  # GET /likes/1/edit
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /likes or /likes.json
  def create
    @like = Like.new(like_params)
    @like.fan_id = current_user

    respond_to do |format|
      if @like.save
        format.html { redirect_back fallback_location: root_url, notice: "Like was successfully created." }
        format.json { render :show, status: :created, location: @like }
        format.js
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @like.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /likes/1 or /likes/1.json
  def update
    respond_to do |format|
      if @like.update(like_params)
        format.html { redirect_to @like, notice: "Like was successfully updated." }
        format.json { render :show, status: :ok, location: @like }
        format.js
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @like.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /likes/1 or /likes/1.json
  def destroy
    @like.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: root_url, notice: "Like was successfully destroyed." }
      format.json { head :no_content }
      
      format.js do
        render template: "likes/destroy"
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_like
    @like = Like.find(params[:id])
  end

  def ensure_current_user_is_owner
    @like = Like.find(params[:id])
    if current_user != @like.fan_id
      redirect_back fallback_location: root_url, alert: "You're not authorized for that."
    end
  end

  # Only allow a list of trusted parameters through.
  def like_params
    params.require(:like).permit(:fan_id, :photo_id)
  end
end

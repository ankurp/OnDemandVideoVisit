class VideoCallsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_video_call, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  # GET /video_calls
  # GET /video_calls.json
  def index
    @video_calls = policy_scope(VideoCall).all
    authorize @video_calls
  end

  # GET /video_calls/1
  # GET /video_calls/1.json
  def show
    authorize @video_call
  end

  # GET /video_calls/new
  def new
    @video_call = VideoCall.new
    authorize @video_call
  end

  # GET /video_calls/1/edit
  def edit
  end

  # POST /video_calls
  # POST /video_calls.json
  def create
    @video_call = VideoCall.new(video_call_params.merge({ users: [current_user] }))
    authorize @video_call
    respond_to do |format|
      if @video_call.save
        format.html { redirect_to @video_call, notice: "Please wait here till the doctor joins." }
        format.json { render :show, status: :created, location: @video_call }
      else
        format.html { render :new }
        format.json { render json: @video_call.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /video_calls/1
  # PATCH/PUT /video_calls/1.json
  def update
    respond_to do |format|
      if @video_call.update(video_call_params)
        format.html { redirect_to @video_call, notice: "Video call was successfully updated." }
        format.json { render :show, status: :ok, location: @video_call }
      else
        format.html { render :edit }
        format.json { render json: @video_call.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /video_calls/1
  # DELETE /video_calls/1.json
  def destroy
    authorize @video_call
    @video_call.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: "Video call was successfully cancelled." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_video_call
    @video_call = policy_scope(VideoCall).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def video_call_params
    params.require(:video_call).permit(:reason)
  end
end

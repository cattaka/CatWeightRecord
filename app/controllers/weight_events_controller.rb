class WeightEventsController < ApplicationController
  before_action :set_weight_event, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  # GET /weight_events
  # GET /weight_events.json
  def index
    @weight_events = WeightEvent.all
  end

  # GET /weight_events/1
  # GET /weight_events/1.json
  def show
  end

  # GET /weight_events/new
  def new
    @weight_event = WeightEvent.new
  end

  # GET /weight_events/1/edit
  def edit
  end

  # POST /weight_events
  # POST /weight_events.json
  def create
    @weight_event = WeightEvent.new(weight_event_params)
    raw_image_file = params[:weight_event][:image_file]
    if raw_image_file
      @weight_event.image_file = ImageFile.create(data: raw_image_file.read)
    end

    respond_to do |format|
      if @weight_event.save
        format.html { redirect_to @weight_event, notice: 'Weight event was successfully created.' }
        format.json { render :show, status: :created, location: @weight_event }
      else
        format.html { render :new }
        format.json { render json: @weight_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /weight_events/1
  # PATCH/PUT /weight_events/1.json
  def update
    respond_to do |format|
      if @weight_event.update(weight_event_params)
        format.html { redirect_to @weight_event, notice: 'Weight event was successfully updated.' }
        format.json { render :show, status: :ok, location: @weight_event }
      else
        format.html { render :edit }
        format.json { render json: @weight_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /weight_events/1
  # DELETE /weight_events/1.json
  def destroy
    @weight_event.destroy
    respond_to do |format|
      format.html { redirect_to weight_events_url, notice: 'Weight event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_weight_event
      @weight_event = WeightEvent.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def weight_event_params
      params.require(:weight_event).permit(:label, :value)
    end
end

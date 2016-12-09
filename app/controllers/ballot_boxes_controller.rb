class BallotBoxesController < ApplicationController
  before_action :set_ballot_box, only: [:show, :edit, :update, :destroy]

  # GET /ballot_boxes
  # GET /ballot_boxes.json
  def index
    @ballot_boxes = BallotBox.all
  end

  # GET /ballot_boxes/1
  # GET /ballot_boxes/1.json
  def show
  end

  # GET /ballot_boxes/new
  def new
    @ballot_box = BallotBox.new
  end

  # GET /ballot_boxes/1/edit
  def edit
  end

  # POST /ballot_boxes
  # POST /ballot_boxes.json
  def create
    @ballot_box = BallotBox.new(ballot_box_params)

    respond_to do |format|
      if @ballot_box.save
        format.html { redirect_to @ballot_box, notice: 'Ballot box was successfully created.' }
        format.json { render :show, status: :created, location: @ballot_box }
      else
        format.html { render :new }
        format.json { render json: @ballot_box.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ballot_boxes/1
  # PATCH/PUT /ballot_boxes/1.json
  def update
    respond_to do |format|
      if @ballot_box.update(ballot_box_params)
        format.html { redirect_to @ballot_box, notice: 'Ballot box was successfully updated.' }
        format.json { render :show, status: :ok, location: @ballot_box }
      else
        format.html { render :edit }
        format.json { render json: @ballot_box.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ballot_boxes/1
  # DELETE /ballot_boxes/1.json
  def destroy
    @ballot_box.destroy
    respond_to do |format|
      format.html { redirect_to ballot_boxes_url, notice: 'Ballot box was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ballot_box
      @ballot_box = BallotBox.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ballot_box_params
      params.fetch(:ballot_box, {})
    end
end

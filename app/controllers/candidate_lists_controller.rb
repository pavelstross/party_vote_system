class CandidateListsController < ApplicationController
  before_action :set_candidate_list, only: [:show, :edit, :update, :destroy]

  # GET /candidate_lists
  # GET /candidate_lists.json
  def index
    @candidate_lists = CandidateList.all
  end

  # GET /candidate_lists/1
  # GET /candidate_lists/1.json
  def show
  end

  # GET /candidate_lists/new
  def new
    @candidate_list = CandidateList.new
  end

  # GET /candidate_lists/1/edit
  def edit
  end

  # POST /candidate_lists
  # POST /candidate_lists.json
  def create
    @candidate_list = CandidateList.new(candidate_list_params)

    respond_to do |format|
      if @candidate_list.save
        format.html { redirect_to @candidate_list, notice: 'Candidate list was successfully created.' }
        format.json { render :show, status: :created, location: @candidate_list }
      else
        format.html { render :new }
        format.json { render json: @candidate_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /candidate_lists/1
  # PATCH/PUT /candidate_lists/1.json
  def update
    respond_to do |format|
      if @candidate_list.update(candidate_list_params)
        format.html { redirect_to @candidate_list, notice: 'Candidate list was successfully updated.' }
        format.json { render :show, status: :ok, location: @candidate_list }
      else
        format.html { render :edit }
        format.json { render json: @candidate_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /candidate_lists/1
  # DELETE /candidate_lists/1.json
  def destroy
    @candidate_list.destroy
    respond_to do |format|
      format.html { redirect_to candidate_lists_url, notice: 'Candidate list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_candidate_list
      @candidate_list = CandidateList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def candidate_list_params
      params.fetch(:candidate_list, {})
    end
end

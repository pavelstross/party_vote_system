class BallotPapersController < ApplicationController
  before_action :set_ballot_paper, only: [:show, :edit, :update, :destroy]

  # GET /ballot_papers
  # GET /ballot_papers.json
  def index
    @ballot_papers = BallotPaper.all
  end

  # GET /ballot_papers/1
  # GET /ballot_papers/1.json
  def show
  end

  # GET /ballot_papers/new
  def new
    @ballot_paper = BallotPaper.new
  end

  # GET /ballot_papers/1/edit
  def edit
  end

  # POST /ballot_papers
  # POST /ballot_papers.json
  def create
    @ballot_paper = BallotPaper.new(ballot_paper_params)

    respond_to do |format|
      if @ballot_paper.save
        format.html { redirect_to @ballot_paper, notice: 'Ballot paper was successfully created.' }
        format.json { render :show, status: :created, location: @ballot_paper }
      else
        format.html { render :new }
        format.json { render json: @ballot_paper.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ballot_papers/1
  # PATCH/PUT /ballot_papers/1.json
  def update
    respond_to do |format|
      if @ballot_paper.update(ballot_paper_params)
        format.html { redirect_to @ballot_paper, notice: 'Ballot paper was successfully updated.' }
        format.json { render :show, status: :ok, location: @ballot_paper }
      else
        format.html { render :edit }
        format.json { render json: @ballot_paper.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ballot_papers/1
  # DELETE /ballot_papers/1.json
  def destroy
    @ballot_paper.destroy
    respond_to do |format|
      format.html { redirect_to ballot_papers_url, notice: 'Ballot paper was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ballot_paper
      @ballot_paper = BallotPaper.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ballot_paper_params
      params.require(:ballot_paper).permit(:vote)
    end
end

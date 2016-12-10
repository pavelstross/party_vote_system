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
    set_election
    @ballot_paper = BallotPaper.new
    @ballot_paper.counting_rules = @election.counting_rules
  end

  # GET /ballot_papers/1/edit
  def edit
  end

  # POST /ballot_papers
  # POST /ballot_papers.json
  def create
    @ballot_paper = BallotPaper.new 
    choices = params[:choices]
    @ballot_paper.vote_hash = hash_of_data(choices)
    vote = [ choices , @ballot_paper.vote_hash ]
    @ballot_paper.encrypted_vote = vote
    @ballot_paper.encrypted_vote_hash = hash_of_data(@ballot_paper.encrypted_vote)
    
    puts "\n\n\n\n\DEBUG\n#{params[:choices]} DEBUG\n\n#{choices}\n#{@ballot_paper.vote_hash}\n#{vote}\n#{@ballot_paper.encrypted_vote}\n#{@ballot_paper.encrypted_vote_hash}\n\n\n\n\DEBUG DEBUG"
   
    respond_to do |format|
      if @ballot_paper
        format.html { redirect_to "/elections/?state=voting" , notice: 'Váš hlas byl uspěšně vložen do volební urny.' }
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

    def hash_of_data(data)
       Digest::SHA2.new(512).hexdigest(data.to_s + SecureRandom.hex(64))
    end

    def set_election
      @election = Election.find(params[:election])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ballot_paper_params
      params.permit(:votes, :choices)
    end
end

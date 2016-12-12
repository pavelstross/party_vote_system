class BallotPapersController < ApplicationController
  
  require 'encryption'
  require "base64"
  before_action :set_ballot_paper, only: [:show, :edit, :update, :destroy]
  before_action :set_election, only: [:new, :create]

  # # GET /ballot_papers
  # # GET /ballot_papers.json
  # def index
  #   @ballot_papers = BallotPaper.all
  # end

  # GET /ballot_papers/1
  # GET /ballot_papers/1.json
  def show
  end

  # GET /ballot_papers/new
  def new
    @ballot_paper = BallotPaper.new
  end

  # # GET /ballot_papers/1/edit
  # def edit
  # end

  # POST /ballot_papers
  # POST /ballot_papers.json

  #vytvoreni, zasifrovani a ulozeni hlasu
  def create
    @ballot_paper = BallotPaper.new(ballot_box: @election.ballot_box)
    authorize! :create, @ballot_paper

    saved = false
    if !@election.is_voting_phase? then
      flash[:error] = 'Nemůžete hlasovat'
    elsif @election.participant_list.has_voted?(current_user['id']) then
      flash[:error] = 'V těchto volbách jste již hlasoval'
    else
      choices = params[:choices]
      salt = SecureRandom.hex(64)
      salted_vote = {choices: choices, salt: salt}
      @ballot_paper.vote_hash = hash_of_data(salted_vote)
      vote = {choices: choices, vote_hash: @ballot_paper.vote_hash, salt: salt}
      public_key = Encryption::PublicKey.new(@election.public_key)
      @ballot_paper.encrypted_vote = Base64.encode64(public_key.encrypt(vote.to_json))
      @ballot_paper.encrypted_vote_hash = hash_of_data(@ballot_paper.encrypted_vote)    
      puts @election.title
      ballot_box = @election.ballot_box
      ballot_box.ballot_papers.build(:encrypted_vote=> @ballot_paper.encrypted_vote, :vote_hash => @ballot_paper.vote_hash, :encrypted_vote_hash => @ballot_paper.encrypted_vote_hash )
      @election.participant_list.add_voter(current_user['id'])
      saved = ballot_box.save && @election.participant_list.save
    end

    respond_to do |format|
      if saved
        format.html { redirect_to "/elections/?state=voting" , notice: 'Váš hlas byl uspěšně vložen do volební urny.' }
        format.json { render :show, status: :created, location: @ballot_paper }
      else
        format.html { render :new }
        format.json { render json: @ballot_paper.errors, status: :unprocessable_entity }
      end
    end
  end

  # # PATCH/PUT /ballot_papers/1
  # # PATCH/PUT /ballot_papers/1.json
  # def update
  #   respond_to do |format|
  #     if @ballot_paper.update(ballot_paper_params)
  #       format.html { redirect_to @ballot_paper, notice: 'Ballot paper was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @ballot_paper }
  #     else
  #       format.html { renedr :edit }
  #       format.json { render json: @ballot_paper.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /ballot_papers/1
  # # DELETE /ballot_papers/1.json
  # def destroy
  #   @ballot_paper.destroy
  #   respond_to do |format|
  #     format.html { redirect_to ballot_papers_url, notice: 'Ballot paper was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ballot_paper
      @ballot_paper = BallotPaper.find(params[:id])
    end

    def hash_of_data_with_salt(data)
       Digest::SHA2.new(512).hexdigest(data.to_s + SecureRandom.hex(64))
    end

    def hash_of_data(data)
       Digest::SHA2.new(512).hexdigest(data.to_s)
    end

    def set_election
      @election = Election.find(params[:election])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ballot_paper_params
      params.permit(:election, :choices)
    end
end

class ElectionsController < ApplicationController
  
  require 'encryption' 
  require 'base64'

  before_action :set_election, only: [:show, :edit, :update, :destroy]

  # GET /elections
  # GET /elections.json
  def index
    if params[:state]
      @elections = Election.where(state: params[:state])
    else
      @elections = Election.all
    end
  end

  # GET /elections/1
  # GET /elections/1.json
  def show
  end

  # GET /elections/new
  def new
    @election = Election.new
  end

  # GET /elections/1/edit
  def edit
  end

  # POST /elections
  # POST /elections.json
  def create
    params = election_params.slice(:title, :description, :election_type, :scope_type, :scope_id_region)
    params[:preparation_starts_at] = parse_datetime_params(election_params, :preparation_starts_at)
    params[:preparation_ends_at] = parse_datetime_params(election_params, :preparation_ends_at)
    params[:voting_starts_at] = parse_datetime_params(election_params, :voting_starts_at)
    params[:voting_ends_at] = parse_datetime_params(election_params, :voting_ends_at)

    puts params

    @election = Election.new(params)

    #vygeneruje novy par verejny/soukromy klic   
    public_key, private_key = Encryption::Keypair.generate( 4096 )
    private_key_file = private_key.to_pem

    # @election.public_key = public_key.to_s
    @election.public_key = Base64.encode64(public_key.to_s)
    
    respond_to do |format|
      if @election.save
        format.html { redirect_to @election, notice: 'Election was successfully created.' }
        format.json { render :show, status: :created, location: @election }
#       send_data private_key_file, filename: "#{@election.id}.pem", type: 'application/x-pem-file'
      else
        format.html { render :new }
        format.json { render json: @election.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /elections/1
  # PATCH/PUT /elections/1.json
  def update
    respond_to do |format|
      if @election.update(election_params)
        format.html { redirect_to @election, notice: 'Election was successfully updated.' }
        format.json { render :show, status: :ok, location: @election }
      else
        format.html { render :edit }
        format.json { render json: @election.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /elections/1
  # DELETE /elections/1.json
  def destroy
    @election.destroy
    respond_to do |format|
      format.html { redirect_to elections_url, notice: 'Election was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_election
      @election = Election.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def election_params
      params.require(:election).permit({ :state => ['preparation', 'voting', 'votes_counted']},
        :election_type, :state, :title, :description, :scope_type, :scope_id_region, :preparation_starts_at,
        :preparation_ends_at, :voting_starts_at, :voting_ends_at, :public_key)
    end
end

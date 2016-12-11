class ElectionsController < ApplicationController
  require 'encryption'
  require 'base64'

  authorize_resource

  before_action :set_election, only: [:show, :edit, :update, :destroy, :count_votes]

  # GET /elections
  # GET /elections.json
  def index
    @state = params[:state]
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
    args = election_params.slice(:eligible_seats, :title, :description, :election_type, :scope_type, :scope_id_region)
    if election_params[:election_type] != 'resolution'
      args[:preparation_starts_at] = parse_datetime_params(election_params, :preparation_starts_at)
      args[:preparation_ends_at] = parse_datetime_params(election_params, :preparation_ends_at)
    end
    args[:voting_starts_at] = parse_datetime_params(election_params, :voting_starts_at)
    args[:voting_ends_at] = parse_datetime_params(election_params, :voting_ends_at)

    @election = Election.new(args)
    @election.ballot_box
    @election.participant_list
    @election.candidate_list

    #vygeneruje novy par verejny/soukromy klic   
    public_key, private_key = Encryption::Keypair.generate( 4096 )

    @election.public_key = public_key.to_s
    @shown_private_key = private_key.to_s
    
    respond_to do |format|
      if (@election.save && @election.ballot_box.save && @election.participant_list.save && @election.candidate_list.save && @election.election_protocol.save)

        format.html { render :show_created, notice: 'Volby byly vytvořeny.'}
        format.json { render :show, status: :created, location: @election }
      else
        format.html { render :new }
        format.json { render json: @election.errors, status: :unprocessable_entity }
      end
    end
    @shown_private_key = nil
  end

  #before_action :verify request_type
  def count_votes
    case request.method_symbol
    #GET /elections/:id/count_votes/  
    when :get
      respond_to do |format|
        format.html { render :count_votes }
      end
    when :post
      saved = false
      if params[:private_key].nil? ||
         !params[:private_key].starts_with?('-----BEGIN RSA PRIVATE KEY-----') ||
         !params[:private_key].ends_with?('-----END RSA PRIVATE KEY-----') then
         flash[:error] = 'Neplatný soukromý klíč'
      else
        if @election.election_type == 'resolution' then
          results = {'resolution' => {for: [], against: []}}
        else
          # create blank results table      
          results = {}
          @election.candidate_list.candidates.each do |candidate|
            results[candidate.id.to_s] = {for: [], against: []}
          end
        end

        # populate result table w/ votes from ballot_box
        @election.ballot_box.ballot_papers.each do |ballot_paper|
          private_key = Encryption::PrivateKey.new(params[:private_key])
          decrypted_vote = JSON.parse(private_key.decrypt(Base64.decode64(ballot_paper.encrypted_vote)))
          puts "decrypted_vote: "
          puts decrypted_vote

          choices = decrypted_vote['choices']
          vote_hash = decrypted_vote['vote_hash']

          choices.each do |candidate_id, choice|
            results[candidate_id][choice.to_sym].push(vote_hash)
          end
        end
        @election.election_protocol.results = results
        @election.count_votes()
        saved = @election.election_protocol.save
      end

      if saved
        respond_to do |format|
          format.html { redirect_to @election.election_protocol, notice: 'Volby byly vyhodnoceny' }
        end
      else
        respond_to do |format|
          format.html {
            flash[:error] ||= 'Při vyhodnocování voleb nastala chyba'
            render :count_votes
          }
        end
      end
    end
  end

  #POST /elections/:id/count_votes/
  #def count_votes
  #  puts "blablabla"
  #end


  # # PATCH/PUT /elections/1
  # # PATCH/PUT /elections/1.json
  # def update
  #   respond_to do |format|
  #     if @election.update(election_params)
  #       format.html { render :show, notice: 'Election was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @election }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @election.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

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
        :election_type, :eligible_seats, :state, :title, :description, :scope_type, :scope_id_region, :preparation_starts_at,
        :preparation_ends_at, :voting_starts_at, :voting_ends_at, :public_key, :private_key)
    end
end

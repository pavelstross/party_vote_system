class ElectionProtocolsController < ApplicationController
  before_action :set_election_protocol, only: [:show, :edit, :update, :destroy]

  # GET /election_protocols
  # GET /election_protocols.json
  def index
    @election_protocols = ElectionProtocol.all
  end

  # GET /election_protocols/1
  # GET /election_protocols/1.json
  def show
  end

  # GET /election_protocols/new
  def new
    @election_protocol = ElectionProtocol.new
  end

  # GET /election_protocols/1/edit
  def edit
  end

  # POST /election_protocols
  # POST /election_protocols.json
  def create
    @election_protocol = ElectionProtocol.new(election_protocol_params)

    respond_to do |format|
      if @election_protocol.save
        format.html { redirect_to @election_protocol, notice: 'Election protocol was successfully created.' }
        format.json { render :show, status: :created, location: @election_protocol }
      else
        format.html { render :new }
        format.json { render json: @election_protocol.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /election_protocols/1
  # PATCH/PUT /election_protocols/1.json
  def update
    respond_to do |format|
      if @election_protocol.update(election_protocol_params)
        format.html { redirect_to @election_protocol, notice: 'Election protocol was successfully updated.' }
        format.json { render :show, status: :ok, location: @election_protocol }
      else
        format.html { render :edit }
        format.json { render json: @election_protocol.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /election_protocols/1
  # DELETE /election_protocols/1.json
  def destroy
    @election_protocol.destroy
    respond_to do |format|
      format.html { redirect_to election_protocols_url, notice: 'Election protocol was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_election_protocol
      @election_protocol = ElectionProtocol.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def election_protocol_params
      params.fetch(:election_protocol, {})
    end
end

class ElectionTransitionWorker
  include Sidekiq::Worker

  def perform(election_id, action)
    election = Election.find(params[:id])
    election.send(action)
    election.save
  end
end
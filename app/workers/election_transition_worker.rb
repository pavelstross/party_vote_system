class ElectionTransitionWorker
  include Sidekiq::Worker

  def perform(election_id, action)
    election = Election.find(election_id)
    election.send(action)
    election.save
  end
end
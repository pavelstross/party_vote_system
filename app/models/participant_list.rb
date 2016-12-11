class ParticipantList
  include Mongoid::Document
  belongs_to :election
  field :voter_ids, type: Array, default: []

  def has_voted?(user_id)
    voter_ids.include?(user_id)
  end

  def add_voter(id)
    return false if has_voted?(id)
    voter_ids.push(id)
    voter_ids.shuffle!
    true
  end
end

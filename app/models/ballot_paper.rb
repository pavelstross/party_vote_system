class BallotPaper
  include Mongoid::Document
  field :encrypted_vote, type: String
  field :vote_hash, type: String
  field :encrypted_vote_hash, type: String
  embedded_in :ballot_box
  
  validates :encrypted_vote, presence: true, allow_blank: false
  validates :vote_hash, presence: true, allow_blank: false
  validates :encrypted_vote_hash, presence: true, allow_blank: false

end

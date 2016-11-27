class BallotPaper
  include Mongoid::Document
  field :vote, type: String
  embedded_in :ballot_box
  validates :vote, presence: true, allow_blank: false
end

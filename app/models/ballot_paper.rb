class BallotPaper
  include Mongoid::Document
  field :vote, type: String
  embedded_in :ballot_box
end

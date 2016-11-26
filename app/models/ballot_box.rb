class BallotBox
  include Mongoid::Document
  belongs_to :election
  embeds_many :ballot_paper
end

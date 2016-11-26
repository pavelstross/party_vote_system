class BallotBox
  include Mongoid::Document
  belongs_to :election
end

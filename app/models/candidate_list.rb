class CandidateList
  include Mongoid::Document
  belongs_to :election
  embeds_many :candidates
end

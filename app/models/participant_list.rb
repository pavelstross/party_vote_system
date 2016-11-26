class ParticipantList
  include Mongoid::Document
  belongs_to :election
end

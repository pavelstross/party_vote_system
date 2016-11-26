class ParticipantList
  include Mongoid::Document
  belongs_to :election
  embeds_many :voter
end

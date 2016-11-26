class Voter
  include Mongoid::Document
  field :id_person_party_registry, type: Integer
  embedded_in :participant_list
end

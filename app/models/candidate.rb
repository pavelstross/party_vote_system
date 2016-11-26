class Candidate
  include Mongoid::Document
  field :id_person_party_registry, type: Integer
  field :first_name, type: String
  field :last_name, type: String
end

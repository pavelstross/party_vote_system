class Election
  include Mongoid::Document
  field :election_type, type: String
  field :state, type: String
  field :title, type: String
  field :description, type: String
  field :scope_type, type: String
  field :scope_id_region, type: Integer
  field :preparation_starts_at, type: Time
  field :preparation_ends_at, type: Time
  field :voting_starts_at, type: Time
  field :voting_ends_at, type: Time
  field :public_key, type: String
end

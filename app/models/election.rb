class Election
  include Mongoid::Document
  include AASM
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
  has_one :ballot_box
  has_one :participant_list

  validates :election_type, inclusion: {
    # usneseni, primarky, funkce ve strane
    in: %w{resolution primaries party_role},
    message: "Neznámý typ voleb: %{value}"
  }
  validates :title, presence: {
    allow_blank: false,
    message: "Název voleb musí být vyplněný"
  }
  validates :scope_type, inclusion: {
    in: %w{region general},
    message: "Neznámá působnost voleb: %{value}"
  }
  validates :scope_id_region, presence: {
    if: :is_region_scope?,
    message: "Krajské volby musí mít nastavený kraj své působnosti"
  }
  validates :scope_id_region, numericality: {
    if: :is_region_scope?,
    only_integer: true
  }
  validates :preparation_starts_at, presence: {
    if: :has_preparation_phase?,
    message: "Datum začátku přihlašování kandidátů musí být vyplněn"
  }
  validates :preparation_ends_at, presence: {
    if: :has_preparation_phase?,
    message: "Datum konce přihlašování kandidátů musí být vyplněn"
  }
  validates :voting_starts_at, presence: {
    message: "Datum začátku hlasování musí být vyplněn"
  }
  validates :voting_ends_at, presence: {
    message: "Datum ukončení hlasování musí být vyplněn"
  }
  validates :public_key, presence: {
    allow_blank: false,
    message: "Veřejný klíč musí být nastaven"
  }

  aasm.attribute_name :state

  aasm do
    state :initialized, :initial => true
    state :preparation
    state :prepared
    state :voting
    state :voting_ended
    state :votes_counted
    
    event :start_preparation do
        transitions :from => :initialized, :to => :preparation, :if => :has_preparation_phase?
    end

    event :stop_preparation do
        transitions :from => :preparation, :to => :prepared, :if => :has_preparation_phase?
    end

    
    event :start_voting do
      transitions :from => :prepared, :to => :voting, :if => :has_preparation_phase?
      transitions :from  => :initialized, :to => :voting, :unless => :has_preparation_phase?
    end

    event :stop_voting do
      transitions :from => :voting, :to => :voting_ended
    end
    
    event :vote_count do
      transitions :from => :voting_ended, :to => :votes_counted
    end
  end

  def is_region_scope?
    scope_type == :region
  end

  def has_preparation_phase?
    self.election_type == 'primaries' || self.election_type == 'party_role'
  end

end
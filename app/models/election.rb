class Election
  include Mongoid::Document
  include AASM
  field :election_type, type: String
  field :state, type: String
  field :title, type: String
  field :description, type: String
  field :scope_type, type: String
  field :scope_id_region, type: Integer
  field :eligible_seats, type: Integer
  field :counting_rules, type: String
  field :preparation_starts_at, type: Time
  field :preparation_ends_at, type: Time
  field :voting_starts_at, type: Time
  field :voting_ends_at, type: Time
  field :public_key, type: String
  has_one :ballot_box, autobuild: true, dependent: :delete
  has_one :participant_list, autobuild: true, dependent: :delete
  has_one :candidate_list, autobuild: true, dependent: :delete
  has_one :election_protocol, autobuild: true, dependent: :delete
 
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

  validates :eligible_seats, presence: {
    if: :has_candidate_list?,
    message: "Primární volby a volby do funkcí ve straně musí mít nastavený počet volitelných míst"
  }

  validates :scope_id_region, numericality: {
    if: :is_region_scope?,
    only_integer: true,
    message: "Krajské volby musí mít nastavený kraj své působnosti"
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
    
    event :count_votes do
      transitions :from => :voting_ended, :to => :votes_counted
    end
  end

  def is_region_scope?
    scope_type == 'region'
  end

  def has_preparation_phase?
    self.election_type == 'primaries' || self.election_type == 'party_role'
  end

  alias :has_candidate_list? :has_preparation_phase?

  def is_voting_phase?
    self.voting?
  end

  def is_election_type_resolution?
    self.election_type == 'resolution'
  end

  def is_more_candidates_than_eligible_seats?
    self.reload
    candidates = self.candidate_list.candidates
    (self.eligible_seats < candidates.count) ? true : false
  end

  def set_counting_rules
    case 
      when is_election_type_resolution? then; self.counting_rules = 'resolution'
      when (!is_election_type_resolution?) && is_more_candidates_than_eligible_seats? then self.counting_rules = 'candidates_choosing'
      when (!is_election_type_resolution?) && (!is_more_candidates_than_eligible_seats?) then self.counting_rules = 'candidates_approval'
    end
  end
end

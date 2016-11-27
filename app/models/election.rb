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
  
  aasm_column :state

  aasm do
    state :initialized, :initial => true
    state :preparation
    state :prepared
    state :voting
    state :voting_ended
    state :votes_counted
    
    event :start_preparation do
      transitions :from => :initialized, :to => :preparation
    end

    event :stop_preparation do
      transitions :from => :preparation, :to => :prepared
    end

    event :start_voting do
      transitions :from => :prepared, :to => :voting
    end
    
    event :stop_voting do
      transitions :from => :voting, :to => :voting_ended
    end
    
    event :vote_count do
      transitions :from => :voting, :to => :votes_counted
    end
  end
end

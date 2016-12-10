class Candidate
  include Mongoid::Document
  embedded_in :candidate_list
  field :id_person_party_registry, type: Integer
  field :first_name, type: String
  field :last_name, type: String
  validates :id_person_party_registry, uniqueness: true

  def full_name
    "#{first_name} #{last_name}"
  end

end

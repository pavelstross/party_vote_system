class ElectionProtocol
  include Mongoid::Document
  belongs_to :election
  field :results, type: Hash
end

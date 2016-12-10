class BallotPaper
  include Mongoid::Document
  field :vote, type: Hash
  field :encrypted_vote, type: String
  field :counting_rules, type: String
  field :vote_hash, type: String
  field :encrypted_vote_hash, type: String
  embedded_in :ballot_box
  validates :vote, presence: true, allow_blank: false


#  def votes
#    self.properties.collect{|k,v| [k,v]}
#  end

#  def votes=(param_hash)
#    # need to ensure deleted values from form don't persist        
 #   self.votes.clear 
 #   votes.each do |name, value|
 #     self.properties[name.to_sym] = value
 #   end  
 # end
end

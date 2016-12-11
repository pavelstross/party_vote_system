class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.nil?

    # Každý uživatel může číst data o volbách    
    can :read, Election

    # Volební komise může manipulovat s daty voleb
    person = user['info']['person']
    person['roles'].each do |role|
      if (role['organization']['name'] == "Volební komise")
        can [:new, :create, :destroy, :count_votes], Election
        can :destroy_candidacy, CandidateList
      end
    end

    if person['person_status'] == 'regular_member' && person['member_status'] == 'regular_member'
      # members
      can :submit_candidacy, CandidateList do |candidate_list|
        election = candidate_list.election
        election.state == 'preparation' &&
          (election.scope_type == 'general' ||
            (election.scope_type == 'region' && election.scope_id_region == person['domestic_region']['id']))
      end
      can [:new, :create], BallotPaper do |ballot_paper|
        election = ballot_paper.ballot_box.election
        election.state == 'voting' &&
          (election.scope_type == 'general' ||
            (election.scope_type == 'region' && election.scope_id_region == person['domestic_region']['id']))
      end
      can [:vote], Election do |election|
        election.state == 'voting' &&
          (election.scope_type == 'general' ||
            (election.scope_type == 'region' && election.scope_id_region == person['domestic_region']['id']))
      end
    end

    if person['person_status'] == 'regular_supporter' && person['supporter_status'] == 'regular_supporter' then
      # supporters
      can [:new, :create], BallotPaper do |ballot_paper|
        election = ballot_paper.ballot_box.election
        election.state == 'voting' &&
          (election.election_type == 'primaries' &&
            (election.scope_type == 'general' ||
              (election.scope_type == 'region' && election.scope_id_region == person['domestic_region']['id'])))
      end
    end

  end
end

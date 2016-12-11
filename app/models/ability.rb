class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.nil?

    # Každý uživatel může číst data o volbách    
    can :read, [Election]

    # Volební komise může manipulovat s daty voleb
    person = user['info']['person']
    person['roles'].each do |role|
      if (role['organization']['name'] == "Volební komise")
        can :manage, [Election]
      end
    end
  end
end

class Ability
  include CanCan::Ability

  def initialize(user)

    # Každý uživatel může číst data o volbách    
    can :read, [Election]

    # Volební komise může manipulovat s daty voleb

    user = user['info']['person']
    user['roles'].each do |role|
      if (role['organization']['name'] == "Volební komise")
        can :manage, [Election]
      end

    end
  
        

  end
end

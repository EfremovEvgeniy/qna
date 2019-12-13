class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :read, Question
      can :create, Question
      can %i[update destroy], Question, user_id: user.id
      can %i[vote_up vote_down], Question
      cannot %i[vote_up vote_down], Question, user_id: user.id
    else
      can :read, Question
    end
  end
end

class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :read, Question
      can :create, [Question, Answer]
      can %i[update destroy], [Question, Answer], user_id: user.id
      can %i[vote_up vote_down], [Question, Answer]
      cannot %i[vote_up vote_down], [Question, Answer], user_id: user.id
      can :make_best, Answer
      can :make_best, Question, user_id: user.id
      cannot :make_best, Answer, user_id: user.id
    else
      can :read, Question
    end
  end
end

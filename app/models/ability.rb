class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user_abilities
    else
      guest_abilities
    end
  end

  def user_abilities
    guest_abilities

    can :create, [Question, Answer]

    can %i[update destroy], [Question, Answer], user_id: user.id

    can %i[vote_up vote_down], [Question, Answer]
    cannot %i[vote_up vote_down], [Question, Answer], user_id: user.id

    can :make_best, Answer
    cannot :make_best, Answer, user_id: user.id

    can :make_best, Question, user_id: user.id

    can :create, Comment

    can :read, Trophy
  end

  def guest_abilities
    can :read, Question
  end
end

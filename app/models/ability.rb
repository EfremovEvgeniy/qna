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
    can :read, [Question, Trophy, Answer]

    can :create, [Question, Answer, Comment, Subscriber]

    can :destroy, Subscriber, id: user.id

    can %i[update destroy], [Question, Answer] do |resource|
      user.author_of?(resource)
    end

    can %i[vote_up vote_down], [Question, Answer] do |votable|
      !user.author_of?(votable)
    end

    can :destroy, ActiveStorage::Attachment do |att|
      user.author_of?(att.record)
    end

    can :destroy, Link do |link|
      user.author_of?(link.linkable)
    end

    can :make_best, Answer do |answer|
      !user.author_of?(answer) && user.author_of?(answer.question)
    end

    can :me, User, id: user.id

    can :answers, Question

    can :index, User
  end

  def guest_abilities
    can :read, [Question, Answer]
    can :answers, Question
  end
end

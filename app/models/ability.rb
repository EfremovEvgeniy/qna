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
    can :read, [Question, Trophy]

    can :create, [Question, Answer, Comment]

    can %i[update destroy], [Question, Answer] do |resource|
      user.author_of?(resource)
    end

    can %i[vote_up vote_down], [Question, Answer] do |votable|
      !user.author_of?(votable)
    end

    can :destroy, ActiveStorage::Attachment do |att|
      user.author_of?(att)
    end

    can :destroy, Link do |link|
      user.author_of?(link.linkable)
    end

    can :make_best, Answer do |answer|
      !user.author_of?(answer)
    end

    can :make_best, Question do |question|
      user.author_of?(question)
    end
  end

  def guest_abilities
    can :read, Question
  end
end

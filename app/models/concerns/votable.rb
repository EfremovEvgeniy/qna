module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def upvote!(user)
    transaction do
      delete_vote(user)
      votes.create!(user: user, value: 1)
    end
  end

  def downvote!(user)
    transaction do
      delete_vote(user)
      votes.create!(user: user, value: -1)
    end
  end

  def total_votes
    votes.sum(:value)
  end

  private

  def delete_vote(user)
    votes.where(user_id: user).delete_all
  end
end

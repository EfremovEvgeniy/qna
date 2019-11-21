module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def upvote!(user)
    transaction do
      votes.where(user_id: user).delete_all
      votes.create!(user: user, value: 1)
    end
  end

  def downvote!(user)
    transaction do
      votes.where(user_id: user).delete_all
      votes.create!(user: user, value: -1)
    end
  end

  def total_votes
    votes.sum(:value)
  end
end

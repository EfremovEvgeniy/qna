class Answer < ApplicationRecord
  include LinksAssociations

  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true

  default_scope { order(best: :desc).order(:created_at) }

  def make_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      if question.trophy
        user = question.answers.where(best: true).first&.user
        question.trophy.update!(user: user)
      end
    end
  end
end

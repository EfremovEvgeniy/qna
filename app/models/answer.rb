class Answer < ApplicationRecord
  include HasLinks

  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true

  default_scope { order(best: :desc).order(:created_at) }

  def make_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      question.trophy&.update!(user: user)
    end
  end
end

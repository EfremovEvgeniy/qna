class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  def make_best
    question.answers.where(best: true).update_all(best: false)
    update!(best: true)
  end
end

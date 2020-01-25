class Answer < ApplicationRecord
  include HasLinks
  include HasComments
  include Votable

  belongs_to :question, touch: true
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true

  default_scope { order(best: :desc).order(:created_at) }

  after_create :send_email

  def make_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      question.trophy&.update!(user: user)
    end
  end

  def send_email
    NotifyNewAnswerJob.perform_later(self)
  end
end

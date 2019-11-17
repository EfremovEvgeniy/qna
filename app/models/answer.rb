class Answer < ApplicationRecord
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

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

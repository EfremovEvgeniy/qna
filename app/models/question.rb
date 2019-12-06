class Question < ApplicationRecord
  include HasLinks
  include HasComments
  include Votable

  has_many :answers, dependent: :destroy
  has_one :trophy, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :trophy, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
end

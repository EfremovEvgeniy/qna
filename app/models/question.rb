class Question < ApplicationRecord
  include HasLinks
  include HasComments
  include Votable

  has_many :answers, dependent: :destroy
  has_one :trophy, dependent: :destroy
  has_many :subscribers, dependent: :destroy

  belongs_to :user

  after_create :create_subscriber

  has_many_attached :files

  accepts_nested_attributes_for :trophy, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  def create_subscriber
    subscribers.create!(user: user)
  end
end

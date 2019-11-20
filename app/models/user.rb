class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :trophies, dependent: :destroy
  has_many :votes, dependent: :destroy

  def author_of?(resource)
    id == resource.user_id
  end
end

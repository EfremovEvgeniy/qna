class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :trophies, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  def self.find_for_oauth(auth, email)
    FindForOauth.new(auth, email).call
  end

  def self.find_by_auth(auth)
    authorization = Authorization.find_by provider: auth.provider, uid: auth.uid.to_s
    return authorization.user if authorization
  end

  def self.find_or_create(email)
    return User.find_by(email: email) if User.find_by(email: email)

    create_user(email)
  end

  def self.create_user(email)
    password = Devise.friendly_token[0, 20]
    User.create!(email: email, password: password, password_confirmation: password)
  end

  def author_of?(resource)
    id == resource.user_id
  end

  def create_authorization(auth)
    authorizations.create!(provider: auth.provider, uid: auth.uid) unless User.find_by_auth(auth)
  end
end

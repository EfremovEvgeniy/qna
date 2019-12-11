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
    user = find_user(email) || find_by_auth(auth)

    user ||= create_user(email)
    user.create_authorization(auth)

    user
  end

  def self.find_by_auth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
  end

  def self.find_or_create(email)
    return find_user(email) if find_user(email)

    create_user(email)
  end

  def self.find_user(email)
    User.find_by(email: email)
  end

  def self.create_user(email)
    password = Devise.friendly_token[0, 20]
    user = User.new(email: email, password: password, password_confirmation: password)
    user.save!
    user
  end

  def author_of?(resource)
    id == resource.user_id
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid) unless User.find_by_auth(auth)
  end
end

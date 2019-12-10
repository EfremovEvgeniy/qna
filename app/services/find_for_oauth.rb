class FindForOauth
  attr_reader :auth

  def initialize(auth, email)
    @auth = auth
    @email = email
  end

  def call
    user = User.find_by(email: @email)

    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    if user
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: @email, password: password, password_confirmation: password)
    end
    user.create_authorization(auth)

    user
  end
end

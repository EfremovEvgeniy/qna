class FindForOauthService
  attr_reader :auth, :email

  def initialize(auth, email)
    @auth = auth
    @email = email
  end

  def call
    user = User.find_by(email: email) || User.find_by_auth(auth)
    user ||= User.create_user_with_rand_password!(email)
    user.authorizations.create!(provider: auth.provider, uid: auth.uid) unless User.find_by_auth(auth)
    user
  end
end

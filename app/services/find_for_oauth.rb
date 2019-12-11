class FindForOauth
  attr_reader :auth, :email

  def initialize(auth, email)
    @auth = auth
    @email = email
  end

  def call
    user = User.find_by(email: email) || User.find_by_auth(auth)
    user ||= User.create_user(email)
    user.create_authorization(auth)
    user
  end
end

module OmniauthMacros
  def mock_auth(provider, email: nil)
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(
      provider: provider.to_s,
      uid: '123456',
      info: {
        name: 'MyUserName',
        email: email
      }
    )
  end
end

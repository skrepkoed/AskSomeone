module OmniauthHelpers
  def mock_auth_github_hash(user)
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
                                                                  'provider' => 'github',
                                                                  'uid' => '123545',
                                                                  'info' => { 'email' => user.email.to_s }
                                                                })
  end

  def mock_auth_google_hash
    OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new({
                                                                  'provider' => 'google_oauth2',
                                                                  'uid' => '123545'
                                                                })
  end

  def authentication_failure(provider)
    OmniAuth.config.mock_auth[provider] = :invalid_credentials
  end
end

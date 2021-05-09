class FindForOauth
  attr_reader :auth
  
  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider:auth.provider, uid:auth.uid.to_s).first
    return authorization.user if authorization
    return User.new unless email = auth.info[:email]
    user = User.find_by(email: email)
    if user
      user.create_authorization(auth)
    else 
      password = Devise.friendly_token[0,20]
      user = User.create!(email:auth.info.email, password: password, password_confirmation: password)
      user.create_authorization(auth)
      user
    end
    user
  end
end
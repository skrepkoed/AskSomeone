class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    omniauth_flow(request.env['omniauth.auth'], 'Github') do
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def google_oauth2
    omniauth_flow(request.env['omniauth.auth'], 'Google') do
      session[:provider] = request.env['omniauth.auth'][:provider]
      session[:uid] = request.env['omniauth.auth'][:uid]

      render 'shared/email_confirmation'
    end
  end

  def confirm
    ConfirmationEmailMailer.confirm_email(params_email, session).deliver_now
    session[:email] = params_email[:email]
    redirect_to root_path
  end

  def confirmed
    if session[:provider] == params[:provider] && session[:uid] == params[:uid]
      auth_hash = OmniAuth::AuthHash.new(provider: params[:provider], uid: params[:uid],
                                         info: { email: session[:email] })
      omniauth_flow(auth_hash, 'Google') do
        redirect_to root_path, alert: 'Something went wrong'
      end
    end
  end

  private

  def params_email
    params.require(:email).permit(:email)
  end

  def omniauth_flow(auth, provider)
    @user = User.find_for_oauth(auth)
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authorization
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      yield
    end
  end
end

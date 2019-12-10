class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    auth = request.env['omniauth.auth']
    sing_in_provider(auth, auth.info[:email])
  end

  def vkontakte
    auth = request.env['omniauth.auth']
    return render 'shared/email' unless session[:email]

    email = session[:email]

    sing_in_provider(auth, email)
  end

  def fill_email
    session[:email] = params[:email]
    User.find_or_create(params[:email])
    redirect_to user_session_path, notice: 'You have to confirm your email address before continuing'
  end

  private

  def sing_in_provider(auth, email)
    @user = User.find_for_oauth(auth, email)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end

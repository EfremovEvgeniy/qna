class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_auth, only: %i[github vkontakte]

  def github
    sing_in_provider(@auth, @auth.info[:email])
  end

  def vkontakte
    return render 'shared/email' unless session[:email]

    email = session[:email]

    sing_in_provider(@auth, email)
  end

  def fill_email
    session[:email] = params[:email]
    User.find_or_create(params[:email])
    redirect_to user_session_path
  end

  private

  def set_auth
    @auth = request.env['omniauth.auth']
  end

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

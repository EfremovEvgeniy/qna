class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth, auth.info[:email])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def vkontakte
    auth = request.env['omniauth.auth']
    render 'shared/email' unless auth.info[:email] || session[:email]

    email = session[:email]

    # @user = User.find_for_oauth(auth, email)

    # if @user&.persisted?
    #   sign_in_and_redirect @user, event: :authentication
    #   set_flash_message(:notice, :success, kind: 'Vkontakte') if is_navigational_format?
    # else
    #   redirect_to root_path, alert: 'Something went wrong'
    # end
  end

  def fill_email
    session[:email] = params[:email]
    User.find_or_create(params[:email])
    redirect_to user_session_path, notice: 'You have to confirm your email address before continuing'
  end
end

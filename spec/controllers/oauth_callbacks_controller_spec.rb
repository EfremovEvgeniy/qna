require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  let!(:user) { create(:user) }

  describe 'github' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @request.env['omniauth.auth'] = mock_auth :github, email: user.email
    end
    let!(:oauth_data) do
      OmniAuth::AuthHash.new(
        provider: 'github',
        uid: '123456',
        info: {
          name: 'MyUserName',
          email: user.email
        }
      )
    end

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data, user.email)
      get :github
    end

    context 'user exists' do
      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end
  end

  describe 'vkontakte' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @request.env['omniauth.auth'] = mock_auth :vkontakte
    end

    context 'user exists' do
      before do
        get :vkontakte
      end

      it 'redirects to enter email page' do
        expect(response).to render_template 'shared/email'
      end

      context 'logins user' do
        before do
          post :fill_email, params: {
            email: user.email
          }
        end

        it 'sets user email in session' do
          expect(session[:email]).to eq user.email
        end

        it 'login user' do
          get :vkontakte
          expect(subject.current_user).to eq user
        end

        it 'redirects to root path' do
          get :vkontakte
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'user does not exist' do
      before do
        get :vkontakte
      end

      it 'redirects to email' do
        expect(response).to render_template 'shared/email'
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end
  end

  describe 'fill_email' do
    before { @request.env['devise.mapping'] = Devise.mappings[:user] }
    describe 'user exist' do
      before do
        post :fill_email, params: {
          email: user.email
        }
      end

      it 'sets user email in session' do
        expect(session[:email]).to eq user.email
      end

      it 'redirects to user_session_path' do
        expect(response).to redirect_to user_session_path
      end

      it 'show flash message' do
        expect(flash[:notice]).to eq 'You can sign in by provider'
      end
    end

    describe 'user does not exist' do
      before do
        post :fill_email, params: {
          email: 'new@gmail.com'
        }
      end

      it 'sets user email in session' do
        expect(session[:email]).to eq 'new@gmail.com'
      end

      it 'redirects to user_session_path' do
        expect(response).to redirect_to user_session_path
      end

      it 'show flash message' do
        expect(flash[:notice]).to eq 'We send you email on new@gmail.com for confirmation '
      end
    end
  end
end

require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  let!(:user) { create(:user) }

  describe 'github' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @request.env['omniauth.auth'] = mock_auth :github, user.email
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
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :vkontakte
      end

      it 'redirects to email' do
        expect(response).to render_template 'shared/email'
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
end

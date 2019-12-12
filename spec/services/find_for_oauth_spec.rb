require 'rails_helper'

RSpec.describe FindForOauthService do
  let!(:user) { create(:user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

  describe '.call' do
    describe 'user already exist' do
      context 'user exist by email' do
        let(:email) { user.email }
        subject { FindForOauthService.new(auth, email) }

        it 'returns user by email' do
          expect(subject.call).to eq user
        end
      end

      context 'user has authorization' do
        subject { FindForOauthService.new(auth, 'user@email.com') }

        it 'returns the user' do
          user.authorizations.create(provider: 'facebook', uid: '123456')

          expect(subject.call).to eq user
        end
      end

      context 'user has not authorization' do
        context 'user already exists' do
          let(:email) { user.email }
          subject { FindForOauthService.new(auth, email) }

          it 'does not create new user' do
            expect { subject.call }.to_not change(User, :count)
          end

          it 'create authorization for user' do
            expect { subject.call }.to change(user.authorizations, :count).by(1)
          end

          it 'returns the user' do
            expect(subject.call).to eq user
          end
        end
      end
    end

    describe 'user does not exist' do
      subject { FindForOauthService.new(auth, 'user@mail.ru') }

      it 'creates new user' do
        expect { subject.call }.to change(User, :count).by(1)
      end

      it 'create authorization for new user' do
        expect { subject.call }.to change(Authorization, :count).by(1)
        expect(subject.call.email).to eq 'user@mail.ru'
      end

      it 'returns new user' do
        expect(subject.call).to eq User.find_by(email: 'user@mail.ru')
      end
    end
  end
end

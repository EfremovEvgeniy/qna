require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:trophies).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123') }
    let(:service) { double('FindForOauth') }

    it 'calls FindForOauth' do
      expect(FindForOauth).to receive(:new).with(auth, user.email).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth, user.email)
    end
  end

  describe '.find_or_create' do
    let!(:user) { create(:user) }

    it 'find need user by email' do
      expect(User.find_or_create(user.email)).to eq user
    end

    it 'creates new user' do
      expect { User.find_or_create('user@mail.ru') }.to change(User, :count).by(1)
    end
  end

  describe '#author_of?(resource)' do
    let(:first_user) { create(:user) }
    let(:second_user) { create(:user) }
    let(:question) { create(:question, user: first_user) }

    it 'should confirm that first_user is an author of the passed resource' do
      expect(first_user).to be_author_of(question)
    end

    it 'should deny that second_user is an author of the passed resource' do
      expect(second_user).to_not be_author_of(question)
    end
  end

  describe '#create_authorization' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123') }

    it 'creates new authorization for user' do
      expect { user.create_authorization(auth) }.to change(user.authorizations, :count).by(1)
    end

    it 'checks new authorization params' do
      authorization = user.create_authorization(auth)

      expect(authorization.provider).to eq auth.provider
      expect(authorization.uid).to eq auth.uid
    end
  end
end

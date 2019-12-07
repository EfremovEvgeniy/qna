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

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123')

        expect(User.find_for_oauth(auth)).to eq user
      end
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
end

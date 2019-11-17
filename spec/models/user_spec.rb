require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:trophies).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'author_of?(resource) method' do
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

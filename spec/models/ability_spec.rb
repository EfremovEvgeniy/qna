require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:second_user) { create(:user) }

    describe 'questions' do
      it { should_not be_able_to :manage, :all }

      it { should be_able_to :create, Question }

      it { should be_able_to :update, create(:question, user_id: user.id) }
      it { should_not be_able_to :update, create(:question, user_id: second_user.id) }

      it { should be_able_to :destroy, create(:question, user_id: user.id) }
      it { should_not be_able_to :destroy, create(:question, user_id: second_user.id) }

      it { should be_able_to :vote_up, create(:question, user_id: second_user.id) }
      it { should_not be_able_to :vote_up, create(:question, user_id: user.id) }

      it { should be_able_to :vote_down, create(:question, user_id: second_user.id) }
      it { should_not be_able_to :vote_down, create(:question, user_id: user.id) }
    end
  end
end
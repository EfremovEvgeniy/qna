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
      it { should be_able_to :create, Question }
      it { should be_able_to :read, Question }

      it { should be_able_to %i[update destroy], create(:question, user_id: user.id) }
      it { should_not be_able_to %i[update destroy], create(:question, user_id: second_user.id) }

      it { should be_able_to %i[vote_up vote_down], create(:question, user_id: second_user.id) }
      it { should_not be_able_to %i[vote_up vote_down], create(:question, user_id: user.id) }
    end

    describe 'answers' do
      it { should be_able_to :create, Answer }

      it { should be_able_to %i[update destroy], create(:answer, user_id: user.id) }
      it { should_not be_able_to %i[destroy destroy], create(:answer, user_id: second_user.id) }

      it { should be_able_to %i[vote_up vote_down], create(:answer, user_id: second_user.id) }
      it { should_not be_able_to %i[vote_up vote_down], create(:answer, user_id: user.id) }

      it { should be_able_to :make_best, create(:answer, user_id: second_user.id) }
      it { should_not be_able_to :make_best, create(:answer, user_id: user.id) }
    end

    describe 'comments' do
      it { should be_able_to :create, Comment }
    end

    describe 'trophies' do
      it { should be_able_to :read, Trophy }
    end

    describe 'links' do
      let(:question) { create(:question, user: user) }
      let(:second_question) { create(:question) }
      it { should be_able_to :destroy, create(:link, linkable: question) }
      it { should_not be_able_to :destroy, create(:link, linkable: second_question) }
    end

    describe 'attachments' do
      it { should be_able_to :destroy, ActiveStorage::Attachment }
    end
  end
end

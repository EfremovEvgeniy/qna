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

      it { should be_able_to %i[update destroy], create(:question, user: user) }
      it { should_not be_able_to %i[update destroy], create(:question, user: second_user) }

      it { should be_able_to %i[vote_up vote_down], create(:question, user: second_user) }
      it { should_not be_able_to %i[vote_up vote_down], create(:question, user: user) }
    end

    describe 'answers' do
      let(:question) { create(:question, user: user) }
      let(:second_question) { create(:question, user: second_user) }

      it { should be_able_to :create, Answer }

      it { should be_able_to %i[update destroy], create(:answer, user: user) }
      it { should_not be_able_to %i[destroy destroy], create(:answer, user: second_user) }

      it { should be_able_to %i[vote_up vote_down], create(:answer, user: second_user) }
      it { should_not be_able_to %i[vote_up vote_down], create(:answer, user: user) }

      it { should be_able_to :make_best, create(:answer, question: question,  user: second_user) }
      it { should_not be_able_to :make_best, create(:answer, question: question, user: user) }
      it { should_not be_able_to :make_best, create(:answer, question: second_question, user: user) }
      it { should_not be_able_to :make_best, create(:answer, question: second_question, user: second_user) }
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

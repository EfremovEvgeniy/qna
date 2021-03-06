require 'rails_helper'

RSpec.describe Answer, type: :model do
  include_examples 'links associations'

  it_behaves_like Votable do
    let(:user) { create(:user) }
    let(:second_user) { create(:user) }
    let(:third_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:votable) { create(:answer, question: question, user: user) }
  end

  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  it 'have many attached file' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'Scope:' do
    let!(:best_answer) { create(:answer, :best) }
    let(:answers) { create_list(:answer, 3, question: best_answer.question) }

    it 'by default return first best answer in collection' do
      expect(best_answer.question.answers).to eq [best_answer, answers.first, answers.second, answers.third]
    end
  end

  describe 'Public methods:' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }

    describe 'Make answer best' do
      context '#make_best!' do
        it 'update attribute best to true' do
          expect { answer.make_best! }.to change(answer, :best).from(false).to(true)
        end
      end

      context '#make_not_best' do
        let(:second_answer) { create(:answer, question: question, user: user) }

        it 'update attribute best to false' do
          answer.make_best!
          second_answer.make_best!
          answer.reload
          second_answer.reload

          expect(answer).to_not be_best
          expect(second_answer).to be_best
        end
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  describe 'Scope:' do
    let(:best_answer) { create(:answer, :best) }
    let(:answers) { create_list(:answer, 3, question: best_answer.question) }

    it 'by default return first best answer in collection' do
      expect(best_answer.question.answers.first).to eq best_answer
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

          expect(answer.best).to eq false
          expect(second_answer.best).to eq true
        end
      end
    end
  end
end

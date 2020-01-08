require 'rails_helper'

RSpec.describe NotifyNewAnswerJob, type: :job do
  let(:question_author) { create(:user) }
  let(:question) { create(:question, user: question_author) }
  let(:answer) { create(:answer, question: question) }
  let(:subscriber) { create(:subscriber, question: question) }

  it 'inform only author and subscribers for new answer' do
    expect(NewAnswerMailer).to receive(:inform).with(answer, question_author).and_call_original
    expect(NewAnswerMailer).to receive(:inform).with(answer, subscriber.user).and_call_original
    expect(NewAnswerMailer).to_not receive(:inform).with(answer, answer.user).and_call_original

    NotifyNewAnswerJob.perform_now(answer)
  end
end

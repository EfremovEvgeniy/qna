require 'rails_helper'

RSpec.describe AnswersChannel, type: :channel do
  let!(:question) { create(:question) }

  before do
    stub_connection
  end

  it 'subscribes to a stream' do
    subscribe(question_id: question.id)
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("questions/#{question.id}/answers")
  end
end

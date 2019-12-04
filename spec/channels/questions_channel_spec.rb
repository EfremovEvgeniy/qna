require 'rails_helper'

RSpec.describe QuestionsChannel, type: :channel do
  before do
    stub_connection
  end

  it 'subscribes to a stream' do
    subscribe
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from('questions_channel')
  end
end

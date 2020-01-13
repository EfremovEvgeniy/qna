require 'rails_helper'

RSpec.describe SearchService do
  describe '.call' do
    describe 'search in scopes' do
      context 'questions scope' do
        let!(:question) { create(:question, title: 'test') }
        let(:search_string) { 'test' }
        let(:search_scope) { 'Questions' }
        subject { SearchService.new(search_string, search_scope) }

        it 'returns exist question' do
          expect(subject.call).to eq question
        end
      end
    end
  end
end
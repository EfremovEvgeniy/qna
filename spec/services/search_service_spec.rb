require 'rails_helper'

RSpec.describe 'SearchService class' do
  describe '.call' do
    let(:query) { 'my_query' }

    describe 'search in scopes' do
      SearchService::SCOPES.each do |search_scope|
        it "calls search in #{search_scope}" do
          expect(search_scope.singularize.classify.constantize).to receive(:search).with(query)
          SearchService.call(query, search_scope)
        end
      end
    end

    describe 'search in all' do
      it 'calls search in all with value smth' do
        expect(ThinkingSphinx).to receive(:search).with(query)
        SearchService.call(query, 'smth')
      end
    end

    describe 'returns result' do
      let!(:question) { create(:question, title: 'my_query') }
      let!(:answer) { create(:answer, body: 'my_query') }
      let!(:user) { create(:user, email: 'my_query@gmail.com') }
      let!(:second_question) { create(:question, title: 'something_else') }
      let!(:second_answer) { create(:answer, body: 'something_else') }
      let!(:second_user) { create(:user, email: 'something_else@gmail.com') }


      it 'returns searched question and does not return else' do
        ThinkingSphinx::Test.run do
          expect((SearchService.call(query, 'Questions'))).to match_array [question]
        end
      end

      it 'returns searched objects and does not return else' do
        ThinkingSphinx::Test.run do
          expect((SearchService.call(query, 'smth'))).to match_array [question, answer, user]
        end
      end
    end
  end
end

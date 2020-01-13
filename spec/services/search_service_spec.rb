require 'rails_helper'

RSpec.describe 'SearchService class' do
  describe '.call' do
    let(:search_string) { 'test' }

    describe 'search in scopes' do
      SearchService::SEARCH_SCOPES.each do |search_scope|
        it "calls search in #{search_scope}" do
          expect(search_scope.singularize.classify.constantize).to receive(:search).with(search_string)
          SearchService.call(search_string, search_scope)
        end
      end
    end

    describe 'search in all' do
      it 'calls search in all with value smth' do
        expect(ThinkingSphinx).to receive(:search).with(search_string)
        SearchService.call(search_string, 'smth')
      end
    end
  end
end
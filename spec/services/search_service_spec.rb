require 'rails_helper'

RSpec.describe 'SearchService class' do
  describe '.call' do
    let(:query) { 'test' }

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
  end
end

require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #search' do
    it 'search in all' do
      expect(ThinkingSphinx).to receive(:search).with 'test'
      get :search, params: { search_string: 'test', search_scope: 'All' }
    end

    %w[Question Answer Comment User].each do |scope|
      it "search in scopes" do
        expect(scope.constantize).to receive(:search).with 'test'
        get :search, params: { search_string: 'test', search_scope: "#{scope}s" }
      end
    end

    it 'render search view' do
      get :search, params: { search_string: 'test', search_scope: 'All' }

      expect(response).to render_template :search
    end
  end
end

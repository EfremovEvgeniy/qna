class SearchController < ApplicationController
  skip_authorization_check  only: :search

  def search
    service = SearchService.new(params[:search_string], params[:search_scope])
    @search_results = service.call
  end
end

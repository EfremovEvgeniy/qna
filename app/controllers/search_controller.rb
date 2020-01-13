class SearchController < ApplicationController
  skip_authorization_check  only: :search

  def search
    @search_results = SearchService.call(params[:search_string], params[:search_scope])
  end
end

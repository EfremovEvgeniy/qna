class SearchService
  SEARCH_SCOPES = %w[Questions Answers Comments Users].freeze

  attr_reader :search_string, :search_scope

  def initialize(search_string, search_scope)
    @search_string = search_string
    @search_scope = search_scope
  end

  def call
    escape_string = ThinkingSphinx::Query.escape(search_string)

    if SEARCH_SCOPES.include?(search_scope)
      search_scope.singularize.classify.constantize.search escape_string, order: 'created_at DESC'
    else
      ThinkingSphinx.search escape_string, order: 'created_at DESC'
    end
  end
end
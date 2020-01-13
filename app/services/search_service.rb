class SearchService
  SEARCH_SCOPES = %w[Questions Answers Comments Users].freeze

  def self.call(search_string, search_scope)
    escape_string = ThinkingSphinx::Query.escape(search_string)

    if SEARCH_SCOPES.include?(search_scope)
      search_scope.singularize.classify.constantize.search escape_string
    else
      ThinkingSphinx.search escape_string
    end
  end
end

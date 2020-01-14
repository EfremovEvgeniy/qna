class SearchService
  SCOPES = %w[Questions Answers Comments Users].freeze

  def self.call(query, scope = nil)
    klass = ThinkingSphinx
    klass = scope.singularize.classify.constantize if SCOPES.include?(scope)

    escaped_query = ThinkingSphinx::Query.escape(query)
    klass.search escaped_query
  end
end

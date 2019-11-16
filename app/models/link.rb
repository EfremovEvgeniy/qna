class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: URI.regexp(%w[http https])

  def gist_content
    return unless gist?

    GistService.new(gist_id(url)).content
  end

  private

  def gist?
    url.match?(%r{^https://gist.github.com/\w+})
  end

  def gist_id(url)
    url.split('/').last
  end
end

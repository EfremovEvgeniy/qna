class GistService
  def initialize(gist_id, client: default_client)
    @gist_id = gist_id
    @client = client
  end

  def content
    @client.gist(@gist_id).files.first[1].content
  rescue Octokit::NotFound
  end

  private

  def default_client
    Octokit::Client.new
  end
end

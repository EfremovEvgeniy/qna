module AttachedConcern
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers

  included do
    has_many :links
    has_many :files
    has_many :comments
  end

  def links
    object.links.map do |l|
      { id: l.id, name: l.name, url: l.url,
        created_at: l.created_at, updated_at: l.updated_at }
    end
  end

  def comments
    object.comments.map do |c|
      { id: c.id, body: c.body, user_id: c.user_id,
        created_at: c.created_at, updated_at: c.updated_at }
    end
  end

  def files
    object.files.map do |file|
      rails_blob_path(file, only_path: true)
    end
  end
end

class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :body, :created_at, :updated_at
  has_many :links
  has_many :comments
  has_many :files

  def files
    object.files.map do |file|
      rails_blob_path(file, only_path: true)
    end
  end
end

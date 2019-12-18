class QuestionSerializer < ActiveModel::Serializer
  include AttachedConcern

  attributes :id, :title, :body, :created_at, :updated_at, :user_id
end

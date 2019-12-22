class AnswerSerializer < ActiveModel::Serializer
  include AttachedConcern

  attributes :id, :body, :user_id, :question_id, :created_at, :updated_at, :best
end

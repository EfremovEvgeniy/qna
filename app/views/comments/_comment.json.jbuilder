json.extract! comment, :id, :body, :commentable_id, :user_id
json.commentable_type comment.commentable_type.downcase

module SearchHelper
  def helper_view_result(result)
    type = result.class.name

    case type
    when 'User'
      tag.i('User: ') + "#{result.email}"
    when 'Question'
      tag.i('Question: ') + link_to_question(result) + " (#{result.body})"
    when 'Answer'
      tag.i('Answer: ') + "(#{result.body}) to the question " + link_to_question(result.question)
    else
      commentable_type = result.commentable_type.downcase
      commentable = result.commentable

      if commentable_type == 'question'
        comment_tag(result, commentable_type) + link_to_question(commentable)
      else
        comment_tag(result, commentable_type) + " (#{commentable.body}), question " + link_to_question(commentable.question)
      end
    end
  end

  def link_to_question(question)
    link_to(question.title, question_path(question), target: '_blank')
  end

  def comment_tag(comment, parent_type)
    tag.i('Comment: ') + "(#{comment.body})" + " to the #{parent_type} "
  end
end

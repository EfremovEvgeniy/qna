import consumer from "./consumer"

consumer.subscriptions.create({ channel:"CommentsChannel", question_id: gon.question_id }, {
  received(data) {
    var comment = JSON.parse(data)

    if (gon.user_id === comment.user_id) {
      return;
    }

    var $newCommentDiv = $("<div id=" + "comment_" + comment.id + "></div>")

    if (comment.commentable_type === 'Question') {
      $('#comments_question_' + comment.commentable_id).append($newCommentDiv)
      $($newCommentDiv).append("<b>Comment:</b>", "<p>" + comment.body + "</p>")
    } else if (comment.commentable_type === 'Answer') {
      $('#comments_answer_' + comment.commentable_id).append($newCommentDiv)
      $($newCommentDiv).append("<b>Comment:</b>", "<p>" + comment.body + "</p>")
    }
  }
});

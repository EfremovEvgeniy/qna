import consumer from "./consumer"

consumer.subscriptions.create("CommentsChannel", {
  connected() {
    if (gon.question_id) {
      this.perform('follow', {
        id: gon.question_id
      });
    }
  },

  disconnected() {
    
  },

  received(data) {
    var comment = JSON.parse(data)

    if (gon.user_id === comment.user_id) {
      return;
    }

    if (comment.commentable_type === 'question') {
      $('#comments_question_' + comment.commentable_id).append('Comment:' + comment.body)
    } else if (comment.commentable_type === 'answer') {
      $('#comments_answer_' + comment.commentable_id).append('Comment:' + comment.body)
    }
  }
});

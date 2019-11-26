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

    var commentableId = comment.commentable_id
    var commentableType = comment.commentable_type

    // if (commentableType === 'question') {
    //   $('#comments_question_' + commentableId).append(JST['templates/comment']({
    //     comment: comment
    //   }));
    // } else if (commentableType === 'answer') {
    //   $('#comments_answer_' + commentableId).append(JST['templates/comment']({
    //     comment: comment
    //   }));
    // }
  }
});

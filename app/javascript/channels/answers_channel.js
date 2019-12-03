import consumer from "./consumer"

consumer.subscriptions.create("AnswersChannel", {
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
    var answer = JSON.parse(data)
    if (gon.user_id !== answer.user_id) {
      var $newAnswerDiv = $("<div id=" + "answer_" + answer.id + "></div>")
      $('.answers').append($newAnswerDiv)
      $($newAnswerDiv).append("<p>" + answer.body + "</p>")
    }
  }
});

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
    console.log(answer)
    if (gon.user_id !== answer.user_id) {
      // передать answer в js template
      // $('.answers').append JST['templates/answer'](answer: answer)
    }
  }
});

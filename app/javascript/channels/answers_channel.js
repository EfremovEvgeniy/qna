import consumer from "./consumer"


consumer.subscriptions.create("AnswersChannel", {
  connected() {
    console.log('Connected');
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
      $('.answers').append(JST['templates/answer']({answer: answer}))
    }
  }
});
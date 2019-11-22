import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    
  },

  disconnected() {
    
  },

  received(data) {
    $('.questions').append(data);
  }
});

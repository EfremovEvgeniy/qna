import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  received(data) {
    var question = JSON.parse(data)
    if (gon.user_id !== question.user_id) {
      var $newQuestionDiv = $("<div id=" + "question_" + question.id + "></div>")
      $('.questions').append($newQuestionDiv)
      $($newQuestionDiv).append("<p>" + question.title + "</p>", "<p>" + question.body + "</p>")
    }
  }
});

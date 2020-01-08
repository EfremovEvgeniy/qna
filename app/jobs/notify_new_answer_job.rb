class NotifyNewAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscribers.find_each do |sub|
      NewAnswerMailer.inform(answer, sub.user).deliver_later unless sub.user.author_of?(answer)
    end
  end
end

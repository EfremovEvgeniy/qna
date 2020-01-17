class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where(created_at: 1.day.ago..Time.current)

    mail to: user.email
  end
end

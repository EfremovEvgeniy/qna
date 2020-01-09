class NewAnswerMailer < ApplicationMailer
  def inform(answer, user)
    @answer = answer

    mail to: user.email
  end
end

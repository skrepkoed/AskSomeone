class QuestionsDigestMailer < ApplicationMailer
  def today_questions(user)
    @questions = Question.today_questions
    mail to: user.email, subject: 'Today in AskSomeone'
  end
end

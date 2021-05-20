class QuestionNotificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.question_notification_mailer.notification.subject
  #
  def notification(subscriber, answer)
    @answer = answer
    @question = answer.question
    mail to: subscriber.email, subject: 'Question your subscribed was answered!'
  end
end

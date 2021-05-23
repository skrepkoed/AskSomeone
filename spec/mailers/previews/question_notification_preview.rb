# Preview all emails at http://localhost:3000/rails/mailers/question_notification
class QuestionNotificationPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/question_notification/notification
  def notification
    QuestionNotificationMailer.notification
  end

end

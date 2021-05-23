class QuestionsNotify
  def send_notification(answer)
    answer.question.subscribers.each do |subscriber|
      QuestionNotificationMailer.notification(subscriber, answer).deliver_later
    end
  end
end
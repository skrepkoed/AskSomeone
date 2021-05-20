class QuestionNotifyJob < ApplicationJob
  queue_as :default

  def perform(answer)
    QuestionsNotify.new.send_notification(answer)
  end
end

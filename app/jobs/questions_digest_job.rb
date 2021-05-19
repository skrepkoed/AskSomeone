class QuestionsDigestJob < ApplicationJob
  queue_as :default

  def perform
    QuestionsDigest.new.send_digest
  end
end

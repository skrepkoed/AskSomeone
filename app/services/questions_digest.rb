class QuestionsDigest
  def send_digest
    User.find_each do |user|
      QuestionsDigestMailer.today_questions(user).deliver_later
    end
  end 
end
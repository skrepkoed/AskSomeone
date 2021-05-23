require "rails_helper"

RSpec.describe QuestionNotificationMailer, type: :mailer do
  describe "notification" do
    let!(:user){ create(:user) }
    let!(:answer){ create(:answer) }
    let(:mail) { QuestionNotificationMailer.notification(user,answer) }
    it "renders the headers" do
      expect(mail.subject).to eq("Question your subscribed was answered!")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi from AskSomeone")
    end
  end
end

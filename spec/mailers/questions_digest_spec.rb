require "rails_helper"

RSpec.describe QuestionsDigestMailer, type: :mailer do
  describe "today_questions" do
    let!(:user){ create(:user) }
    let(:mail) { QuestionsDigestMailer.today_questions(user) }
    it "renders the headers" do
      expect(mail.subject).to eq("Today in AskSomeone")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi from Asksomeone")
    end
  end
end

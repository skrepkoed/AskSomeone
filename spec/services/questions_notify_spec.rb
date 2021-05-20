require 'rails_helper'
RSpec.describe QuestionsNotify do
  let!(:answer){ create(:answer) }
  subject { QuestionsNotify.new }
  it 'sends notifiacation about new answer to subscribers' do
    expect(QuestionNotificationMailer).to receive(:notification).and_call_original
    subject.send_notification(answer)
  end
end
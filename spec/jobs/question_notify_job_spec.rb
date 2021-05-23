require 'rails_helper'

RSpec.describe QuestionNotifyJob, type: :job do
  let(:service) { double('QuestionsNotify') }
  let(:answer){ create(:answer) }
  before do
    allow(QuestionsNotify).to receive(:new).and_return(service)
  end

  it 'calls QuestionsDigest#send_digest' do
    expect(service).to receive(:send_notification).with(answer)
    QuestionNotifyJob.perform_now(answer)
  end
end

require 'rails_helper'

RSpec.describe QuestionsDigestJob, type: :job do
 let(:service) { double('QuestionsDigest') }

  before do
    allow(QuestionsDigest).to receive(:new).and_return(service)
  end

  it 'calls QuestionsDigest#send_digest' do
    expect(service).to receive(:send_digest)
    QuestionsDigestJob.perform_now
  end
end

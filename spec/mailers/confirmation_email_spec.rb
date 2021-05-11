require 'rails_helper'

RSpec.describe ConfirmationEmailMailer, type: :mailer do
  describe 'confirm_email' do
    let!(:user) { create(:user) }
    let(:mail) do
      ConfirmationEmailMailer.confirm_email({ email: user.email }, { provider: 'google_oauth2', uid: '123456' })
    end

    it 'renders the headers' do
      expect(mail.subject).to eq('Confirm email to Asksomeone')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Hi')
    end
  end
end

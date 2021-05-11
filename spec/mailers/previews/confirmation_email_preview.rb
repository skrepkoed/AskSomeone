# Preview all emails at http://localhost:3000/rails/mailers/confirmation_email
class ConfirmationEmailPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/confirmation_email/confirm_email
  def confirm_email
    ConfirmationEmailMailer.confirm_email({ email: User.find(1).email }, { provider: 'google_oauth2', uid: '123456' })
  end
end

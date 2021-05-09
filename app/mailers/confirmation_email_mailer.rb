class ConfirmationEmailMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.confirmation_email_mailer.confirm_email.subject
  #
  def confirm_email(email, auth)
    @provider = auth[:provider]
    @uid = auth[:uid] 
    @email = email[:email]
    mail to: @email, subject: 'Confirm email to Asksomeone'
  end
end

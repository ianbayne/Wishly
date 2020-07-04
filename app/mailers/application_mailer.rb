class ApplicationMailer < ActionMailer::Base
  default "Message-ID": -> {
    "<#{SecureRandom.uuid}@#{ActionMailer::Base.smtp_settings[:domain]}>"
  }

  default from: "wishly-support@#{ActionMailer::Base.smtp_settings[:domain]}"
  layout 'mailer'
end

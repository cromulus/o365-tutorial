class UserNotifierMailer < ApplicationMailer
  def invalid_token(user)
    email_body = "please login to refresh your calendar's connection to outlook\n"
    email_body += "just click the link below!\n"
    email_body += "https://calfeed.dokku.brl.nyc/refresh/#{user.token}"
    email_body += "\n"
    email_body += "remember, your login is name@rhnyc.net and your password!\n"
    email_body += 'pester Bill with questions'
    user.notified_at = Time.zone.now
    user.save
    mail(to: user.email,
         body: email_body,
         from: ENV['SMTP_USERNAME'],
         content_type: 'text/html',
         subject: 'Update your calendar feed!')
  end
end

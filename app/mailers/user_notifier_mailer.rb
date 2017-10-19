class UserNotifierMailer < ApplicationMailer
  def invalid_token(user)
    email_body = "please login to refresh your calendar's connection to outlook\n"
    email_body += "just click the link below!\n"
    email_body += "https://calfeed.dokku.brl.nyc/refresh/#{user.token}"
    email_body += "\n"
    email_body += "remember, your login is name@rhnyc.net and your password!\n"
    email_body += 'pester Bill with questions'

    mail(to: user.email,
         body: email_body,
         from: ENV['SMTP_USER'],
         content_type: 'text/html',
         subject: 'Update your calendar feed!')
    user.inactive_notification = true
    user.notified_at = Time.zone.now
    user.save
  end
end

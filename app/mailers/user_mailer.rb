class UserMailer < ApplicationMailer

default from: 'ithelper@jaspermayone.com'

def hello()
  mail(
    subject: "Hello from Postmark",
    to: "me@jaspermayone.com",
    html_body: "<strong>Hello</strong> dear Postmark user.",
    track_opens: "true",
    message_stream: "outbound"
  )
end

end

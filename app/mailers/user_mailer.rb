class UserMailer < ApplicationMailer

default from: 'ithelper@jaspermayone.com'

def notify_unreturned_after_seven_days(loan)
  @loan = loan
  @borrower = Borrower.find(@loan.borrower_id)
  mail(
    subject: "Student has not returned Loaner after seven days.",
    to: "jmayone2025@huusd.org",
    track_opens: "true",
    message_stream: "outbound"
  )
end

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

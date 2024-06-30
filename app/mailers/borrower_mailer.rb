class BorrowerMailer < ApplicationMailer

default from: 'ithelper@jaspermayone.com'

def notify_repair_ready(borrower)
  @borrower = borrower
  mail(
    to: @borrower.email,
    subject: 'Your device has been repaired.',
    track_opens: "true",
    track_clicks: "true",
    message_stream: "outbound"
    )
end

def notify_loaner_disabled(borrower)
  @borrower = borrower
  mail(
    to: @borrower.email,
    subject: 'Your device has been disabled.',
    track_opens: "true",
    track_clicks: "true",
    message_stream: "outbound"
    )
end

def return_reminder(borrower)
  @borrower = borrower
  mail(
    to: @borrower.email,
    subject: 'Please return your device.',
    track_opens: "true",
    track_clicks: "true",
    message_stream: "outbound"
    )
end

end

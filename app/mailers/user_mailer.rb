class UserMailer < ApplicationMailer
  default from: 'ithelper@jaspermayone.com'

  def notify_unreturned_after_seven_days(loan)
    # StatsD.increment("email.notify_unreturned_after_seven_days_sent")
    # StatsD.measure('email.notify_unreturned_after_seven_days_delivery_time') do
      @loan = loan
      @borrower = Borrower.find(@loan.borrower_id)
      mail(
        subject: "Student has not returned Loaner after seven days.",
        to: "jmayone2025@huusd.org",
        track_opens: "true",
        message_stream: "outbound"
      )
    # end
  end

  def hello
    # StatsD.increment("email.hello_sent")
    # StatsD.measure('email.hello_delivery_time') do
      mail(
        subject: "Hello from Postmark",
        to: "me@jaspermayone.com",
        html_body: "<strong>Hello</strong> dear Postmark user.",
        track_opens: "true",
        message_stream: "outbound"
      )
    end
  # end
end

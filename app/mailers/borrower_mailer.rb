class BorrowerMailer < ApplicationMailer
  default from: 'ithelper@jaspermayone.com'

  def notify_repair_ready(borrower)
    StatsD.increment("email.notify_repair_ready_sent")
    StatsD.measure('email.notify_repair_ready_delivery_time') do
      @borrower = borrower
      mail(
        # to: @borrower.email,
        to: "jgriffith@huusd.org",
        subject: 'Your device has been repaired.',
        track_opens: "true",
        track_clicks: "true",
        message_stream: "outbound"
      )
    end
  end

  def notify_loaner_disabled(borrower)
    StatsD.increment("email.notify_loaner_disabled_sent")
    StatsD.measure('email.notify_loaner_disabled_delivery_time') do
      @borrower = borrower
      mail(
        # to: @borrower.email,
        to: "jgriffith@huusd.org",
        subject: 'Your device has been disabled.',
        track_opens: "true",
        track_clicks: "true",
        message_stream: "outbound"
      )
    end
  end

  def return_reminder(borrower)
    StatsD.increment("email.return_reminder_sent")
    StatsD.measure('email.return_reminder_delivery_time') do
      # @borrower = borrower
      mail(
        # to: @borrower.email,
        to: "jgriffith@huusd.org",
        subject: 'Please return your device.',
        track_opens: "true",
        track_clicks: "true",
        message_stream: "outbound"
      )
    end
  end
end

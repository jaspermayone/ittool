class BorrowerUnreturnedAfterSevenDaysJob < ApplicationJob
  queue_as :default

  def perform(*args)
    loan_id = args[0]
    loan = Loan.find(loan_id)

    # check if loaner is due
    if loan.due_date < Date.today && loan.status == "out"
      UserMailer.notify_unreturned_after_seven_days(loan).deliver_now
    end

  end
end

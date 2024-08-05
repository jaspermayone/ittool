class DisableDeviceJob < ApplicationJob
  include Audited::ActiveJob
  queue_as :default

  def perform(*args)
    loan_id = args[0]
    loan = Loan.find(loan_id)
    loaner = loan.loaner

    if loan.due_date < Date.today && loan.status == "out"
      loaner.disable!
    end

  end
end

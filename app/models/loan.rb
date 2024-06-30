# == Schema Information
#
# Table name: loans
#
#  id          :integer          not null, primary key
#  due_date    :date
#  loaned_at   :datetime
#  reason      :integer
#  returned_at :datetime
#  status      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  borrower_id :integer          not null
#  loaner_id   :integer
#
# Indexes
#
#  index_loans_on_borrower_id  (borrower_id)
#  index_loans_on_loaner_id    (loaner_id)
#  index_loans_on_status       (status)
#
# Foreign Keys
#
#  borrower_id  (borrower_id => borrowers.id)
#  loaner_id    (loaner_id => loaners.id)
#
class Loan < ApplicationRecord
  include AASM

  belongs_to :borrower
  belongs_to :loaner, optional: true  # Allow loaner to be optional
  validates :reason, presence: true

  aasm :column => 'status' do

    state :pending, initial: true, display: "Pending"
    state :out, display: "Out"
    state :returned, display: "Returned"

    after_all_transitions :log_status_change

    event :loan do
      transitions from: :pending, to: :out

      after do
        self.update(loaned_at: Time.now)
        # SHOWME: This is the time for the due date, confirm this with justin
        self.update(due_date: Date.today + 1.day)

        due_date_time = self.due_date.to_time

        RemindBorrowerToReturnLoanerJob.set(wait_until: due_date_time + 1.day).perform_later(self.id)
        RemindBorrowerToReturnLoanerJob.set(wait_until: due_date_time + 2.days).perform_later(self.id)
        RemindBorrowerToReturnLoanerJob.set(wait_until: due_date_time + 3.days).perform_later(self.id)
        RemindBorrowerToReturnLoanerJob.set(wait_until: due_date_time + 4.days).perform_later(self.id)
        RemindBorrowerToReturnLoanerJob.set(wait_until: due_date_time + 5.days).perform_later(self.id)
        RemindBorrowerToReturnLoanerJob.set(wait_until: due_date_time + 6.days).perform_later(self.id)
        RemindBorrowerToReturnLoanerJob.set(wait_until: due_date_time + 7.days).perform_later(self.id)
        BorrowerUnreturnedAfterSevenDaysJob.set(wait_until: due_date_time + 8.days).perform_later(self.id)
      end
    end

    event :return do
      transitions from: :out, to: :returned

      after do
        self.update(returned_at: Time.now)
      end
    end

  end

  def log_status_change
    puts "changing from #{aasm.from_state} to #{aasm.to_state} (event: #{aasm.current_event})"
  end

  enum reason: { charging: 1, device_repair: 2, forgot_at_home: 3 }
end

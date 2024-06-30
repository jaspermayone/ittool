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
        StatsD.increment("loan.loaned")
        self.update(loaned_at: Time.now)
        self.update(due_date: Date.today + 1.day)

        due_date_time = self.due_date.to_time

        # Schedule reminder jobs
        (1..7).each do |day|
          StatsD.increment("loan.reminder_job_scheduled", tags: ["day:#{day}"])
          RemindBorrowerToReturnLoanerJob.set(wait_until: due_date_time + day.days).perform_later(self.id)
        end
        StatsD.increment("loan.borrower_unreturned_after_seven_days_job_scheduled")
        BorrowerUnreturnedAfterSevenDaysJob.set(wait_until: due_date_time + 8.days).perform_later(self.id)
      end
    end

    event :return do
      transitions from: :out, to: :returned

      after do
        StatsD.increment("loan.returned")
        self.update(returned_at: Time.now)
      end
    end
  end

  def log_status_change
    StatsD.increment("loan.status_change", tags: ["from:#{aasm.from_state}", "to:#{aasm.to_state}", "event:#{aasm.current_event}"])
    Rails.logger.info "Changing from #{aasm.from_state} to #{aasm.to_state} (event: #{aasm.current_event})"
  end

  enum reason: { charging: 1, device_repair: 2, forgot_at_home: 3 }
end

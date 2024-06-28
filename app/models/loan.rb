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

class Loan < ApplicationRecord
  include AASM

  aasm :column => 'status' do
    state :pending, initial: true
    state :out
    state :returned

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

  enum reason: { charging: 1, device_repair: 2, forgot_at_home: 3 }

  belongs_to :borrower
  belongs_to :loaner, optional: true  # Allow loaner to be optional

  validates :reason, presence: true
end

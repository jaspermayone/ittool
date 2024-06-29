# == Schema Information
#
# Table name: loaners
#
#  id              :integer          not null, primary key
#  asset_tag       :string
#  serial_number   :string
#  status          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  current_loan_id :integer
#  loaner_id       :integer
#
# Indexes
#
#  index_loaners_on_asset_tag        (asset_tag)
#  index_loaners_on_current_loan_id  (current_loan_id)
#  index_loaners_on_loaner_id        (loaner_id)
#  index_loaners_on_status           (status)
#
# Foreign Keys
#
#  current_loan_id  (current_loan_id => loans.id)
#
class AssetTagValidator < ActiveModel::Validator
  def validate(record)
  unless record.asset_tag =~ /^[0-9]{6}$/
    record.errors.add(:asset_tag, 'must be a 6-digit number')
  end
end
end

class Loaner < ApplicationRecord
  include AASM

  before_create :set_loaner_id

  aasm column: 'status' do
    state :available, initial: true, display: "Available"
    state :loaned, display: "Loaned"
    state :disabled, display: "Disabled"
    state :maintenance, display: "Maintenance"

    after_all_transitions :log_status_change

    event :loan do
      # transitions from: :available, to: :loaned, guard: :pending_loan_present?
      transitions from: :available, to: :loaned

      after do
        assign_current_loan
      end
    end

    event :return do
      transitions from: :loaned, to: :available
    end

    event :disable do
      transitions from: [:available, :loaned], to: :disabled
    end

    event :enable do
      transitions from: :disabled, to: :available
    end

    event :broken do
      transitions from: [:available, :loaned], to: :maintenance
    end

    event :repair do
      transitions from: :maintenance, to: :available
    end
  end

  def log_status_change
    puts "changing from #{aasm.from_state} to #{aasm.to_state} (event: #{aasm.current_event})"
  end

  # def pending_loan_present?
  #   loans.pending.exists?
  # end

  def assign_current_loan
    current_loan = loans.pending.first
    if current_loan
      self.current_loan_id = current_loan.id
      save!
      current_loan.loan!
    end
  end

  validates :asset_tag, presence: true, uniqueness: true
  validates_with AssetTagValidator
  validates :serial_number, uniqueness: true
  validates :loaner_id, presence: true, uniqueness: true

  has_many :loans, foreign_key: 'loaner_id'
  has_one :current_loan, -> { where(status: 'out').order(loaned_at: :desc) }, class_name: 'Loan'
  has_many :borrowers, through: :loans

  private

  def set_loaner_id
    # Find the maximum current loaner_id
    max_id = Loaner.maximum(:loaner_id) || 0
    self.loaner_id = max_id + 1
  end

end

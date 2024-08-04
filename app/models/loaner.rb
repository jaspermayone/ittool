# == Schema Information
#
# Table name: loaners
#
#  id              :integer          not null, primary key
#  active          :boolean
#  asset_tag       :string
#  serial_number   :string
#  status          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  current_loan_id :integer
#  freindly_id     :integer
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
    # Increment a counter for validation attempts
    StatsD.increment("asset_tag_validation_attempts")

    if record.asset_tag.blank?
      # Log and increment counter for blank asset tag errors
      StatsD.increment("asset_tag_validation_blank_errors")
      record.errors.add(:asset_tag, "can't be blank")
    elsif record.asset_tag =~ /^[0-9]{6}$/
      # Log successful validation
      StatsD.increment("asset_tag_validation_success")
    else
      # Log and increment counter for format errors
      StatsD.increment("asset_tag_validation_format_errors")
      record.errors.add(:asset_tag, 'must be a 6-digit number')
    end
  end
end

class Loaner < ApplicationRecord
  include AASM

  before_create :set_loaner_id

  def chrome_device
    GoogleService.new.get_chrome_device(self.serial_number)
  end

  def chrome_status
    chrome_device.status
  end

  def chrome_status_update(status)
    chrome_device.status = status
    GoogleService.new.update_chrome_device(self.serial_number, chrome_device)
  end

  def chrome_disable
    chrome_status_update("DISABLED")
  end

  def chrome_enable
    chrome_status_update("ACTIVE")
  end

  aasm column: 'status' do
    state :available, initial: true, display: "Available"
    state :loaned, display: "Loaned"
    state :disabled, display: "Disabled"
    state :maintenance, display: "Maintenance"

    after_all_transitions :log_status_change

    event :loan do
      transitions from: :available, to: :loaned

      after do
        StatsD.increment("loaner.loaned")
        assign_current_loan
      end
    end

    event :return do
      transitions from: :loaned, to: :available

      after do
        StatsD.increment("loaner.returned")

        self.current_loan.return!
      end
    end

    event :disable do
      transitions from: [:available, :loaned], to: :disabled

      after do
        chrome_disable()
        StatsD.increment("loaner.disabled")
      end
    end

    event :enable do
      transitions from: :disabled, to: :available

      after do
        chrome_enable()
        StatsD.increment("loaner.enabled")
      end
    end

    event :broken do
      transitions from: [:available, :loaned], to: :maintenance

      after do
        StatsD.increment("loaner.broken")
      end
    end

    event :repair do
      transitions from: :maintenance, to: :available

      after do
        StatsD.increment("loaner.repaired")
      end
    end
  end

  def log_status_change
    StatsD.increment("loaner.status_change", tags: ["from:#{aasm.from_state}", "to:#{aasm.to_state}", "event:#{aasm.current_event}"])
    Rails.logger.info "Changing from #{aasm.from_state} to #{aasm.to_state} (event: #{aasm.current_event})"
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
    StatsD.measure("loaner.set_loaner_id_time") do
      max_id = Loaner.maximum(:loaner_id) || 0
      self.loaner_id = max_id + 1
      StatsD.increment("loaner.id_set")
    end
  end

  def assign_current_loan
    StatsD.measure("loaner.assign_current_loan_time") do
      current_loan = loans.pending.first
      if current_loan
        self.current_loan_id = current_loan.id
        save!
        StatsD.increment("loaner.current_loan_assigned")
        current_loan.loan!
      end
    end
  end
end

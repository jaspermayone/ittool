class AssetTagValidator < ActiveModel::Validator
  def validate(record)
  unless record.asset_tag =~ /^[0-9]{6}$/
    record.errors.add(:asset_tag, 'must be a 6-digit number')
  end
end
end

class Loaner < ApplicationRecord
  include AASM

  aasm :column => 'status' do

    state :available, initial: true
    state :loaned
    state :disabled
    state :maintenance

    event :loan do
      transitions from: :available, to: :loaned
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

  def mark_as_broken
    broken!
  end

  def mark_as_repaired
    repair!
  end

  def mark_as_loaned
    loan!
  end

  def mark_as_returned
    return!
  end

  def mark_as_disabled
    disable!
  end

  def mark_as_enabled
    enable!
  end


  def loan_count
    loans.count
  end

  validates :asset_tag, presence: true, uniqueness: true
  validates_with AssetTagValidator
  validates :serial_number, uniqueness: true
  validates :loaner_id, presence: true, uniqueness: true
  has_many :loans, foreign_key: 'loaner_id'
  has_many :borrowers, through: :loans
end

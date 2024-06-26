class Asset < ApplicationRecord
  vlaidates :asset_id, presence: true

end

class Loaner < Asset
  include AASM

  aasm :column => 'status' do

    state :available, initial: true
    state :loaned
    state :maintenance

    event :loan do
      transitions from: :available, to: :loaned
    end

    event :return do
      transitions from: :loaned, to: :available
    end

    event :broken do
      transitions from: [:available, :loaned], to: :maintenance
    end

    event :repair do
      transitions from: :maintenance, to: :available
    end

  end

  validates :loaner_id, presence: true
  has_many :loans
  has_many :borrowers, through: :loans
end

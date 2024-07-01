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
require "test_helper"

class LoanerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

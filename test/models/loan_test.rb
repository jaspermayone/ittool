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
require "test_helper"

class LoanTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

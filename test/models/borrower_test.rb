# == Schema Information
#
# Table name: borrowers
#
#  id              :integer          not null, primary key
#  email           :string
#  first_name      :string
#  flagged         :boolean
#  graduation_year :integer
#  last_name       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class BorrowerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

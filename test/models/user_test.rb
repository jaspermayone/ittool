# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string
#  f_name          :string
#  l_name          :string
#  password_digest :string
#  role            :integer          default("viewer"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: employee_data
#
#  id          :integer          not null, primary key
#  name        :string
#  employee_id :string
#  designation :string
#  department  :string
#  manager     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class EmployeeDatumTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

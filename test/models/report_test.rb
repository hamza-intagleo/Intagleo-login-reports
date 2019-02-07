# == Schema Information
#
# Table name: reports
#
#  id              :integer          not null, primary key
#  emp_id          :string
#  time_in_office  :float
#  time_out_office :float
#  source          :string
#  report_date     :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

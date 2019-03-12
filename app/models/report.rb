# == Schema Information
#
# Table name: reports
#
#  id              :integer          not null, primary key
#  emp_id          :string(255)
#  time_in_office  :float(24)
#  time_out_office :float(24)
#  source          :string(255)
#  report_date     :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Report < ApplicationRecord
end

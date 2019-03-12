# == Schema Information
#
# Table name: hrm_employee_data
#
#  id                  :integer          not null, primary key
#  emp_firstname       :string(255)
#  emp_lastname        :string(255)
#  employee_id         :string(255)
#  punch_in_user_time  :datetime
#  punch_out_user_time :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class HrmEmployeeDatum < ApplicationRecord
end

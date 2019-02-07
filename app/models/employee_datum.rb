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

class EmployeeDatum < ApplicationRecord
  validates_uniqueness_of :employee_id
end

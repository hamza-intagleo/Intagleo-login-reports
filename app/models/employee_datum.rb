# == Schema Information
#
# Table name: employee_data
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  employee_id :string(255)
#  designation :string(255)
#  department  :string(255)
#  manager     :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  has_left    :boolean          default(FALSE)
#

class EmployeeDatum < ApplicationRecord
  validates_uniqueness_of :employee_id
  has_many :time_sheets , dependent: :destroy
  has_many :events , dependent: :destroy
end

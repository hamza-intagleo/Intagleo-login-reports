# == Schema Information
#
# Table name: time_sheets
#
#  id                :integer          not null, primary key
#  date              :date
#  employee_datum_id :integer
#  productive_hours  :float(24)
#  task_description  :string(255)
#  break_hours       :float(24)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class TimeSheet < ApplicationRecord
  belongs_to :employee_datum
end

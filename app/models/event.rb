# == Schema Information
#
# Table name: events
#
#  id                :integer          not null, primary key
#  emp_id            :string
#  employee_datum_id :integer
#  login_time        :datetime
#  login_date        :date
#  event_type        :string
#  event_id          :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Event < ApplicationRecord
  belongs_to :employee_datum
end

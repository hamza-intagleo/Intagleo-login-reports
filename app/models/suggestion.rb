# == Schema Information
#
# Table name: suggestions
#
#  id              :integer          not null, primary key
#  emp_id          :string(255)
#  description     :text(65535)
#  suggestion_type :string(255)
#  addon           :time
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Suggestion < ApplicationRecord
end

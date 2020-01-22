# == Schema Information
#
# Table name: feedbacks
#
#  id                   :integer          not null, primary key
#  emp_id               :string(255)
#  feedback_question_id :integer
#  feedback_answer_id   :integer
#  feedback_type        :string(255)
#  addon                :time
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Feedback < ApplicationRecord
end

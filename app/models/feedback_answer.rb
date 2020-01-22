# == Schema Information
#
# Table name: feedback_answers
#
#  id                   :integer          not null, primary key
#  emp_id               :string(255)
#  feedback_question_id :integer
#  description          :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class FeedbackAnswer < ApplicationRecord
end

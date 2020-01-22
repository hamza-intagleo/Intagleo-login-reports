# == Schema Information
#
# Table name: question_options
#
#  id                   :integer          not null, primary key
#  feedback_question_id :integer
#  option               :string(255)
#  feedback_option_type :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class QuestionOption < ApplicationRecord
  belongs_to :feedback_question
end

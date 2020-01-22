# == Schema Information
#
# Table name: feedback_questions
#
#  id            :integer          not null, primary key
#  creater       :string(255)
#  question_type :string(255)
#  description   :text(65535)
#  has_option    :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class FeedbackQuestion < ApplicationRecord
  has_many :question_options
end

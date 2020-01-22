class FeedbackQuestionController < ApplicationController
  def index
    @feedback  = Feedback.new
    @feedback_questions = FeedbackQuestion.all
  end
  def edit
    byebug
  end
  def create
    byebug
  end

end

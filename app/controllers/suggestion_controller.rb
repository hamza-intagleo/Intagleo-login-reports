class SuggestionController < ApplicationController
  def index
  end
  def new
    @suggestion = Suggestion.new
  end
  def create
    @suggestion = Suggestion.new(update_suggestion_params)
    @suggestion.emp_id = current_user.email
    @suggestion.addon = Time.now
    if @suggestion.save
      flash[:notice] = "Suggestion added successfully"
      redirect_to new_suggestion_path
    end
  end
  def update_suggestion_params
    params.require(:suggestion).permit(:suggestion_type, :description)
  end
end

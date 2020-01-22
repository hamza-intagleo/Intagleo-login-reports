class CreateFeedbackAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :feedback_answers do |t|
      t.string :emp_id
      t.references :feedback_question, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end

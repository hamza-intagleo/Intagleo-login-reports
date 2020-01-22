class CreateFeedbackQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :feedback_questions do |t|
      t.string :creater
      t.string :question_type
      t.text :description
      t.boolean :has_option

      t.timestamps
    end
  end
end

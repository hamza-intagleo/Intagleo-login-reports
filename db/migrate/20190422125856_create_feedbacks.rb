class CreateFeedbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :feedbacks do |t|
      t.string :emp_id
      t.references :feedback_question, foreign_key: true
      t.references :feedback_answer, foreign_key: true
      t.string :feedback_type
      t.time :addon

      t.timestamps
    end
  end
end

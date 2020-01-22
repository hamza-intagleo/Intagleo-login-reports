class CreateQuestionOptions < ActiveRecord::Migration[5.0]
  def change
    create_table :question_options do |t|
      t.references :feedback_question, foreign_key: true
      t.string :option
      t.string :feedback_option_type
      t.timestamps
    end
  end
end

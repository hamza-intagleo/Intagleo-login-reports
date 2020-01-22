class CreateSuggestions < ActiveRecord::Migration[5.0]
  def change
    create_table :suggestions do |t|
      t.string :emp_id
      t.text :description
      t.string :suggestion_type
      t.time :addon

      t.timestamps
    end
  end
end

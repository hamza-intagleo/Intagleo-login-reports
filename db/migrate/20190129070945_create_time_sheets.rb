class CreateTimeSheets < ActiveRecord::Migration[5.0]
  def change
    create_table :time_sheets do |t|
      t.date :date
      t.references :employee_datum, foreign_key: true
      t.float :productive_hours
      t.string :task_description
      t.float :break_hours

      t.timestamps
    end
  end
end

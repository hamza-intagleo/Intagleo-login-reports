class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :emp_id
      t.references :employee_datum, foreign_key: true
      t.datetime :login_time
      t.date :login_date
      t.string :type
      t.integer :event_id

      t.timestamps
    end
  end
end

class CreateEmployeeData < ActiveRecord::Migration[5.0]
  def change
    create_table :employee_data do |t|
      t.string :name
      t.string :employee_id
      t.string :designation
      t.string :department
      t.string :manager

      t.timestamps
    end
  end
end

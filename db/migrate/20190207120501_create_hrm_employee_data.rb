class CreateHrmEmployeeData < ActiveRecord::Migration[5.0]
  def change
    create_table :hrm_employee_data do |t|
      t.string :emp_firstname
      t.string :emp_lastname
      t.string :employee_id
      t.datetime :punch_in_utc_time
      t.datetime :punch_out_utc_time

      t.timestamps
    end
  end
end

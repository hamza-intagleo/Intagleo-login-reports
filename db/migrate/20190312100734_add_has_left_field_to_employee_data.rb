class AddHasLeftFieldToEmployeeData < ActiveRecord::Migration[5.0]
  def change
    add_column :employee_data, :has_left, :boolean, default: false
  end
end

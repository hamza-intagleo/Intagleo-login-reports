class ChangePunchInUtcTime < ActiveRecord::Migration[5.0]
  def change
    rename_column :hrm_employee_data, :punch_in_utc_time, :punch_in_user_time
    rename_column :hrm_employee_data, :punch_out_utc_time, :punch_out_user_time
  end
end

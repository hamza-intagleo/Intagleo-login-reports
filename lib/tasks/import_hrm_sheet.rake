namespace :import_hrm_sheet do

  desc 'Import HRM sheet data'
  task :import_file => :environment do
    connection = ActiveRecord::Base.establish_connection(:adapter  => "mysql2", :host     => "192.168.101.197", :username => "root", :password => "root", :database => "int_hr_mysql")
    @connection = ActiveRecord::Base.connection
    results = @connection.exec_query("SELECT hs_hr_employee.emp_firstname,hs_hr_employee.emp_lastname,hs_hr_employee.employee_id,ohrm_attendance_record.punch_in_utc_time,ohrm_attendance_record.punch_out_utc_time, DATE(ohrm_attendance_record.punch_in_utc_time) as date FROM ohrm_attendance_record INNER JOIN hs_hr_employee on ohrm_attendance_record.employee_id = hs_hr_employee.emp_number WHERE hs_hr_employee.termination_id IS NULL AND ohrm_attendance_record.punch_in_utc_time >= '2019-01-01' AND ohrm_attendance_record.punch_out_utc_time <= '2019-01-10' ORDER BY date ASC")
    old_connection = ActiveRecord::Base.establish_connection(:adapter  => "mysql2", :host     => "localhost", :username => "root", :password => "root", :database => "emloyee_reports_hrm")
    results.each do |data_row|
      HrmEmployeeDatum.create!(data_row)
      # productive_hours = ((data_row['punch_out_utc_time'] - data_row['punch_in_utc_time'])/3600).round(1)
      Report.create!(emp_id: data_row['employee_id'], time_in_office: data_row['punch_in_utc_time'], time_out_office: data_row['punch_out_utc_time'], source: 'HRM_ATTENDENCE', report_date: data_row['punch_in_utc_time'].to_date)
    end
  end
end

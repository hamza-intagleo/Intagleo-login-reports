namespace :import_hrm_sheet do

  desc 'Import HRM sheet data'
  task :import_file => :environment do
    connection = ActiveRecord::Base.establish_connection(:adapter  => "mysql2", :host     => "192.168.101.197", :username => "root", :password => "root", :database => "int_hr_mysql")
    @connection = ActiveRecord::Base.connection
    results = @connection.exec_query("SELECT hs_hr_employee.emp_firstname,hs_hr_employee.emp_lastname,hs_hr_employee.employee_id,ohrm_attendance_record.punch_in_user_time,ohrm_attendance_record.punch_out_user_time, DATE(ohrm_attendance_record.punch_in_user_time) as date FROM ohrm_attendance_record INNER JOIN hs_hr_employee on ohrm_attendance_record.employee_id = hs_hr_employee.emp_number WHERE hs_hr_employee.termination_id IS NULL AND ohrm_attendance_record.punch_in_user_time >= '2019-01-01' AND ohrm_attendance_record.punch_out_user_time <= '2019-03-01' ORDER BY date ASC")
    old_connection = ActiveRecord::Base.establish_connection(:adapter  => "mysql2", :host     => "localhost", :username => "root", :password => "root", :database => "emloyee_reports_hrm")

    results.each do |data_row|
      hrmEmpObj = HrmEmployeeDatum.find_by(employee_id: data_row['employee_id'].upcase,punch_in_user_time: data_row['punch_in_user_time'])
        unless hrmEmpObj.present?
        HrmEmployeeDatum.create!(data_row.except!("date"))

        if data_row['punch_in_user_time'].to_date == data_row['punch_out_user_time'].to_date
          productive_hours = ((data_row['punch_out_user_time'] - data_row['punch_in_user_time'])/3600).round(1)
        else
          if data_row['punch_out_user_time'] > data_row['punch_in_user_time']
            productive_hours = ((data_row['punch_out_user_time'] - data_row['punch_in_user_time'])/3600).round(1)
          else
            productive_hours = (((data_row['punch_out_user_time'] - data_row['punch_in_user_time'])/3600)-12).round(1)
          end
        end
        reportObj = Report.find_by(emp_id: data_row['employee_id'], source: 'HRM_ATTENDENCE', report_date: data_row['punch_in_user_time'].to_date)
        if reportObj.present?
          reportObj.time_in_office = reportObj.time_in_office + productive_hours
        else
          Report.create!(emp_id: data_row['employee_id'], time_in_office: productive_hours, time_out_office: data_row['punch_out_user_time'], source: 'HRM_ATTENDENCE', report_date: data_row['punch_in_user_time'].to_date)
        end
        puts "Data Created"
        puts data_row
      end
    end
  end
end

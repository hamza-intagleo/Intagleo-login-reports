namespace :import_all_employee do

  desc 'Import HRM sheet data'
  task :import_file => :environment do
    xlsx = Roo::Spreadsheet.open('public/all_emp/hs_hr_employee(6).csv')
    data = xlsx.sheet(0)

    data.each_with_index do |d,index|
    	emp = EmployeeDatum.find_by(employee_id: d[0])
    	unless emp.present?
    		emp = EmployeeDatum.new(employee_id: d[0],name: d[1])
      		emp.save
    	end
    end

  end
end

namespace :import_time_sheet do

  desc 'Import excel sheet data'
  task :import_file => :environment do
    require 'roo'

    files = Dir.entries('public/Hr Sheets')
    files.each do |file|
      unless file == '.' || file == '..'
        xlsx = Roo::Spreadsheet.open("public/Hr Sheets/"+file)
        data = xlsx.sheet(0)
        emp = EmployeeDatum.new
        ts = nil
        emp_id = nil
        checkFlag = true
        data.each_with_index do |d,index|
            begin
            unless index == 0 && index <3
              # for column 1
              if d[0] == "Employee Name:"
                if d[2].present?
                  emp.name = d[2]
                  puts "name ",d[2]
                else
                  emp.name = d[1]
                end
              elsif d[0] == "Designation:"
                if d[2].present?
                  emp.designation = d[2]
                  puts "desgnation ",d[2]
                else
                  emp.designation = d[1]
                end
              end
              # for column 2
              if d[4] == "Employee ID:"
                emp.employee_id = d[5]
                puts "id",d[5]
              elsif d[4] == "Department"
                puts "dpt ",d[5]
                emp.department = d[5]
              elsif d[4] == "Manager's Name:"
                puts "mgr"
                emp.manager = d[5]
              end
            end

            if index == 3
              ed = EmployeeDatum.find_by(employee_id: emp.employee_id)
              if ed.present?
                emp_id = ed.id
              else
                emp.save
                emp_id = emp.id
              end
              unless emp_id.present?
                EmployeeDatum.find_by
              end
            end
            rp = Report.new
            if index > 5
              unless d[2].to_s == "Days Total"
                if d[1].present?
                  ts = TimeSheet.find_by(date: d[1],employee_datum_id: emp_id)
                  if ts.present?
                    if d[3].present?
                      ts.productive_hours = ts.productive_hours + (d[3].to_f / 3600)
                    end
                    ts.save
                  else
                    ts = TimeSheet.new(productive_hours: 0.0)
                    ts.date = d[1]
                    if d[3].present?
                      ts.productive_hours = (d[3].to_f / 3600)
                    end
                    ts.employee_datum_id = emp_id
                    ts.save
                  end
                else
                  ts = TimeSheet.where(employee_datum_id: emp_id).last
                  if ts.present?
                    ts.date = ts.date
                    if d[3].present?
                      ts.productive_hours = ts.productive_hours + (d[3].to_f / 3600)
                    end
                    ts.employee_datum_id = emp_id
                    ts.save
                  end
                end
              else

                ts = TimeSheet.where(employee_datum_id: emp_id).last

                rp.emp_id = emp.employee_id
                rp.time_in_office = ts.productive_hours rescue []
                rp.source = 'HR Sheet'
                rp.report_date = ts.date rescue []
                rp.save
              end
            end

          rescue => ex
          end
        end
      end
    end




  end
  def time_sheet_data
  end
end
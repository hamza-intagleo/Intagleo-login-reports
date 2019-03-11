namespace :import_time_sheet do

  desc 'Import excel sheet data'
  task :import_file => :environment do
    require 'roo'

    years = Dir.entries('public/Hr Sheets')
    years.each do |month|
      unless month == "." || month == ".."
        months = Dir.entries('public/Hr Sheets/'+month)
        months.each do |filesheets|

          unless filesheets == "." || filesheets == ".."
            files  = Dir.entries('public/Hr Sheets/'+ month + "/" + filesheets)
            files.each do |file|
              begin
              loginFiles = LoginFile.find_by(filename: file)
              unless (file == '.' || file == '..')
                xlsx = Roo::Spreadsheet.open("public/Hr Sheets/"+ month + "/" + filesheets + "/" +file)
                datas = xlsx.sheets
                datas.each_with_index do |da,index|
                  begin
                    data = xlsx.sheet(index)
                    emp = EmployeeDatum.new
                    ts = nil
                    emp_id = nil
                    checkFlag = true
                    temporaryDate = nil
                    update_time = true
                    data.each_with_index do |d,index|
                        begin
                        unless index == 0 && index <3
                          # for column 1
                          if d[0] == "Employee Name:"
                            if d[2].present?
                              emp.name = d[2].upcase
                              puts "name ",d[2]
                            else
                              emp.name = d[1].upcase
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
                            # emp.save
                            emp_id = emp.id
                          end
                          unless emp_id.present?
                            EmployeeDatum.find_by
                          end
                        end
                        rp = Report.new
                        if index > 5

                          if d[1].present?
                            temporaryDate = d[1]
                          end
                          unless d[2].to_s == "Days Total" || d[2].to_s == " Total" || d[2].to_s.include?("Total")

                            if d[1].present?
                              # if file == "Timesheet - 201902 - IS308 - Haroon Shahzaib Nasir.xlsx"
                              #   byebug
                              # end
                              if d[1].present?
                                sheetDate = d[1]
                              else
                                sheetDate = temporaryDate
                              end
                              ts = TimeSheet.find_by(date: sheetDate,employee_datum_id: emp_id)
                              if ts.present?
                                if d[3].present?
                                  if update_time
                                    ts.productive_hours = 0.0
                                    update_time = false
                                  end
                                  ts.productive_hours = ts.productive_hours + (d[3].to_f / 3600)
                                end
                                ts.save
                              else
                                ts = TimeSheet.new(productive_hours: 0.0)
                                if d[1].present?
                                  sheetDate = d[1]
                                else
                                  sheetDate = temporaryDate
                                end
                                ts.date = sheetDate
                                if d[3].present?
                                  ts.productive_hours = (d[3].to_f / 3600)
                                end
                                ts.employee_datum_id = emp_id
                                ts.save
                              end
                            else
                              ts = TimeSheet.find_by(date: temporaryDate,employee_datum_id: emp_id)
                              # ts = TimeSheet.where(employee_datum_id: emp_id).last
                              if ts.present?
                                ts.date = ts.date
                                if d[3].present?
                                  if update_time
                                    ts.productive_hours = 0.0
                                    update_time = false
                                  end
                                  ts.productive_hours = ts.productive_hours + (d[3].to_f / 3600)
                                end
                                ts.employee_datum_id = emp_id
                                ts.save
                              end
                            end
                          else
                            update_time = true
                            # if file == "Timesheet - 201902 - IS308 - Haroon Shahzaib Nasir.xlsx"
                            #   byebug
                            # end
                            ts = TimeSheet.find_by(date: temporaryDate,employee_datum_id: emp_id)
                            # ts = TimeSheet.where(employee_datum_id: emp_id).last
                            begin
                              rp1 = Report.find_by(emp_id: emp.employee_id,report_date: ts.date,source: 'HR Sheet')
                              if rp1.present?
                                rp = rp1
                              end
                            end
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
              LoginFile.create(filename: file)
              rescue => ex
                puts "=========> #{file}",ex
              end
            end
          end
        end
      end
    end




  end
  def time_sheet_data
  end
end
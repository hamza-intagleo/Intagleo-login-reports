namespace :import_loginDetail do
  desc 'Import login details data'
  task :import_login => :environment do
    require 'roo'

    files = Dir.entries('public/Network Sheets')
    productiveHours = nil
    files.each do |file|
      unless file == '.' || file == '..'
        xlsx = Roo::Spreadsheet.open('public/Network Sheets/'+file)
        data = xlsx.sheet(0)
        timeSheetDate = nil
        employeeIdArray = []
        previous_Time = nil
        loopStarter = false
        data.each_with_index do |d,index|
          unless index == 0
            e = Event.new
            begin
              employee_id = d[0].split('=')[1]
              employee_id = employee_id[0..employee_id.length-2]
              dateAndTime = d[1].split(" ")
              dateSplit = dateAndTime[0]
              timeSplit = dateAndTime[1]
              timeSpan = dateAndTime[2]
              dateSplit = dateSplit.split("/")
              day = dateSplit[0]
              month = dateSplit[1]
              year = dateSplit[2]

              user = EmployeeDatum.find_by(employee_id: employee_id)
              e.emp_id = employee_id
              e.employee_datum_id = user.id
              e.login_date = Date.parse("#{month}-#{day}-#{year}")
              timeSheetDate = e.login_date
              e.login_time = timeSplit + " " + timeSpan
              e.event_id = d[3]
              e.event_type = d[4]
              if e.event_type == nil || e.event_type == ''
                e.event_type = "Logoff"
              end

              if e.save
                unless employeeIdArray.include? employee_id
                  employeeIdArray << employee_id
                end
              end
            rescue => ex
              puts "=======> #{index}"
            end
          end
        end
        employeeIdArray.each do |empId|

          events = Event.where("emp_id = ? AND login_date = ? AND time(login_time) >= ?", empId, timeSheetDate, "07:00")
          events2 = Event.where("emp_id = ? AND login_date = ? AND time(login_time) <= ?", empId, timeSheetDate+1, "07:00")
          # events = Event.where(emp_id: empId,login_date: timeSheetDate)
          if events.present?
            event = events.sort_by {|x| x.login_time}
            if events2.present?
              event2 = events2.sort_by {|x| x.login_time}
              event = event + event2
            end
            productiveHours = 0.0
            event.each_with_index do |cal,index|
              if loopStarter
                unless event[index] == nil
                  if event[index].event_type == "System was Locked" || event[index].event_type == "System Shutdown" || event[index].event_type == "User initiated logoff" || event[index].event_type == "Logoff"
                    if event[index].login_time < previous_Time
                      productiveHours = productiveHours + ((((event[index].login_time) - previous_Time)/3600)+24)
                    else
                      productiveHours = productiveHours + ((event[index].login_time - previous_Time)/3600)
                    end
                    loopStarter = false
                  end
                end
              end
              if (cal.event_type == "Logon" || cal.event_type == "System was UnLock" || cal.event_type == "System Startup" ) && !loopStarter && cal.present?
                if event[index].event_type == "System was UnLock"
                end
                unless event[index+1] == nil
                  if event[index+1].event_type == "System was Locked" || event[index+1].event_type == "System Shutdown" || event[index+1].event_type == "User initiated logoff" || event[index+1].event_type == "Logoff"
                    if event[index+1].login_time < event[index].login_time
                      productiveHours = productiveHours + (((event[index+1].login_time - event[index].login_time)/3600)+24)
                    else
                      productiveHours = productiveHours + ((event[index+1].login_time - event[index].login_time)/3600)
                    end
                  else
                    loopStarter = true
                    if event[index].present?
                      previous_Time = event[index].login_time
                    end
                  end
                end
              end
            end
            unless loopStarter
              rp = Report.new
              rp.emp_id = empId
              rp.time_in_office = productiveHours
              rp.source = 'Network Sheet'
              rp.report_date = timeSheetDate
              rp.save
            end
          end

        end
      end
    end





  end
  def time_sheet_data
  end
end
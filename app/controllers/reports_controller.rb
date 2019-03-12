class ReportsController < ApplicationController
  before_action :authenticate_user!
  require 'rubygems'
  require 'write_xlsx'
  require 'rubygems'
  require 'zip'
  def index
    if params[:start_date].present? && params[:end_date].present?
      startDate = params[:start_date].split('/')
      month = startDate[0] rescue ""
      day = startDate[1] rescue ""
      year = startDate[2] rescue ""
      startDate = params[:end_date].split('/')
      month2 = startDate[0] rescue ""
      day2 = startDate[1] rescue ""
      year2 = startDate[2] rescue ""
      @start_Date = (day +"-" + month +"-" + year).to_date
      @end_date = (day2 +"-" + month2 +"-" + year2).to_date
      # @reports = Report.where(report_date: year+"-"+month+"-"+day...year2+"-"+month2+"-"+((day2.to_i) +1).to_s,source: "Network Sheet")
    else
      @start_Date = ('2019-02-26').to_date
      @end_date = ('2019-03-06').to_date
    end
    if params[:search_name].present?
      @employees = EmployeeDatum.where("name LIKE ?", "%#{params[:search_name]}%")
    else
      @employees = EmployeeDatum.all.order("employee_id")
    end
    # @reports = Report.group(report_date,emp_id).order('report_date asc')
    # @reports = Report.order('report_date asc').group_by{|rep| [rep.report_date, rep.emp_id,rep.source]}

  end
  
  def search_by_dates
    if params[:start_date].present? && params[:end_date]
      startDate = params[:start_date].split('/')
      month = startDate[0] rescue ""
      day = startDate[1] rescue ""
      year = startDate[2] rescue ""
      startDate = params[:end_date].split('/')
      month2 = startDate[0] rescue ""
      day2 = startDate[1] rescue ""
      year2 = startDate[2] rescue ""
      @start_Date = (day +"-" + month +"-" + year).to_date
      @end_date = (day2 +"-" + month2 +"-" + year2).to_date
      @employees = EmployeeDatum.all
      # @reports = Report.where(report_date: year+"-"+month+"-"+day...year2+"-"+month2+"-"+((day2.to_i) +1).to_s,source: "Network Sheet")
    end
    render 'index'
  end
  def change_employee_position
    if params[:left] == "true"
      emp = EmployeeDatum.find params[:empid]
      emp.has_left = false
      emp.save
    else
      emp = EmployeeDatum.find params[:empid]
      emp.has_left = true
      emp.save
    end

  end
  def employees_list
    @list = EmployeeDatum.all
  end
  def download_sheet(zip_data,filename)
    send_data(zip_data, :type => 'application/zip', :filename => filename)
    puts "--------------------"
    puts "--------------------"
  end
  def generate_sheet
    # byebug
    @start_Date = ('2019-01-07').to_date
    @end_Date = ('2019-02-28').to_date
    @employees = EmployeeDatum.all.order("employee_id")

    (@start_Date..@end_Date).each do |date_report|
      filenam = date_report.to_s
      workbook = WriteXLSX.new("public/Reports/intagleo report "+ filenam +".xlsx")
      worksheet = workbook.add_worksheet
      format = workbook.add_format
      format2 = workbook.add_format
      row = 2
      format.set_bold
      format2.set_color('red')
      worksheet.write(0, 0, "ID",format)
      worksheet.write(0, 1, "Name",format)
      worksheet.write(0, 2, "HR Sheet Time",format)
      worksheet.write(0, 3, "Network Sheet Time",format)
      worksheet.write(0, 4, "HRM Attendance Total Time",format)
      worksheet.write(0, 5, "Report Date",format)
      worksheet.write(0, 6, "Status",format)
      @employees.each do |emp|
        r1 = Report.find_by(emp_id: emp.employee_id,report_date: date_report, source: "HR Sheet")
        r2 = Report.find_by(emp_id: emp.employee_id,report_date: date_report, source: "Network Sheet")
        r3 = Report.find_by(emp_id: emp.employee_id,report_date: date_report, source: "HRM_ATTENDENCE")
        # next unless r1.present? || r2.present? || r3.present?


        worksheet.write(row, 0, emp.employee_id)
        worksheet.write(row, 1, emp.name)
        if r1.present?
          if r1.time_in_office > 0 && r1.time_in_office <= 3
            worksheet.write(row, 2, r1.time_in_office.round(1),format2)
          else
            worksheet.write(row, 2, r1.time_in_office.round(1))
          end

        end
        if r2.present?
          if r2.time_in_office > 0 && r2.time_in_office <= 3
            worksheet.write(row, 3, r2.time_in_office.round(1),format2)
          else
            worksheet.write(row, 3, r2.time_in_office.round(1))
          end

        end
        if r3.present?
          if r3.time_in_office > 0 && r3.time_in_office <= 3
            worksheet.write(row, 4, r3.time_in_office,format2)
          else
            worksheet.write(row, 4, r3.time_in_office)
          end

        end
        worksheet.write(row, 5, date_report)
        diff = nil
        if r1.present? && r1.time_in_office != 0
          if r2.present? && r2.time_in_office - r1.time_in_office <= -2 && r2.time_in_office != 0
            diff = r2.time_in_office - r1.time_in_office
          else
            if r3.present?
              if (r3.time_in_office.round(1) - r1.time_in_office) <= -2 && r3.time_in_office != 0
                diff = r3.time_in_office.round(1) - r1.time_in_office
              end
            end
          end
        else
          if r3.present? && r2.present?
            if (r2.time_in_office.round(1) - r3.time_in_office) <= -3 && r2.time_in_office != 0
              diff = r2.time_in_office.round(1) - r3.time_in_office
            end
          end
        end
        if diff.present?
          worksheet.write(row, 6, diff, format2)
        end
        row = row + 1
      end
      workbook.close
    end



    folder = "public"
    filename = 'Intagleo_Reports.zip'
    temp_file = Tempfile.new(filename)

    reportFiles = Dir.entries('public/Reports')
    Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip_file|
      reportFiles.each do |d|
        unless d == "." || d == ".."
          zip_file.add(d,"public/Reports/"+d)
        end
      end
    end
    zip_data = File.read(temp_file.path)
    # redirect_to download_sheet_reports_path(zip_data,filename)
    send_data(zip_data, :type => 'application/zip', :filename => filename)
    # render :json=>{"status"=>"success"}
   
    # ============old code=============
    # workbook = WriteXLSX.new('intagleo report.xlsx')
    # worksheet = workbook.add_worksheet
    # format = workbook.add_format
    # format2 = workbook.add_format
    # row = 2
    # format.set_bold
    # format2.set_color('red')
    # worksheet.write(0, 0, "ID",format)
    # worksheet.write(0, 1, "Name",format)
    # worksheet.write(0, 2, "Network Sheet Time",format)
    # worksheet.write(0, 3, "HR Sheet Time",format)
    # worksheet.write(0, 4, "HRM Attendance Total Time",format)
    # worksheet.write(0, 5, "Report Date",format)
    # worksheet.write(0, 6, "Status",format)
    # reports = Report.where(source: "Network Sheet")
    # reports.each_with_index do |report,index|
    #   r1 = Report.find_by(emp_id: report.emp_id,report_date: report.report_date, source: "HR Sheet")
    #   r2 = Report.find_by(emp_id: report.emp_id,report_date: report.report_date, source: "HRM_ATTENDENCE")
    #
    #   worksheet.write(row, 0, report.emp_id)
    #   worksheet.write(row, 1, EmployeeDatum.find_by(employee_id: report.emp_id).name)
    #   worksheet.write(row, 2, report.time_in_office.round(1))
    #   if r1.present?
    #     worksheet.write(row, 3, r1.time_in_office.round(1))
    #   end
    #   if r2.present?
    #     worksheet.write(row, 4, r2.time_in_office)
    #   end
    #   worksheet.write(row, 5, report.report_date)
    #   if r1.present?
    #     if report.time_in_office - r1.time_in_office < -2 && report.time_in_office != 0
    #       worksheet.write(row, 6, (report.time_in_office - r1.time_in_office).round(1),format2)
    #     else
    #       if r2.present?
    #         if (report.time_in_office.round(1) - r2.time_in_office) < -3 && report.time_in_office != 0
    #           worksheet.write(row, 6, (report.time_in_office - r2.time_in_office).round(1),format2)
    #         else
    #           if r1.time_in_office - r2.time_in_office <-3 && r1.time_in_office != 0
    #             worksheet.write(row, 6, (r1.time_in_office - r2.time_in_office).round(1),format2)
    #           end
    #         end
    #       end
    #     end
    #   else
    #     if r2.present?
    #       if (report.time_in_office.round(1) - r2.time_in_office) < -3 && report.time_in_office != 0
    #         worksheet.write(row, 6, (report.time_in_office - r2.time_in_office).round(1),format2)
    #       end
    #     end
    #   end
    #   # if r2.present?
    #   #   if (report.time_in_office.round(1) - r2.time_in_office) < -3
    #   #     format2.set_color('red')
    #   #     worksheet.write(row,0, format2)
    #   #   end
    #   # end
    #   row = row + 1
    # end
    # workbook.close
    # redirect_to root_path

  end
end

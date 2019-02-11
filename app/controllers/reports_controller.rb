class ReportsController < ApplicationController
  def index
    @reports = Report.where(source: "Network Sheet")
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
      @reports = Report.where(report_date: year+"-"+month+"-"+day...year2+"-"+month2+"-"+((day2.to_i) +1).to_s,source: "Network Sheet")
    end
    render 'index'
  end
end

module AttendancesHelper
require 'rounding'
  
  def working_times(start,finish)
    format("%.2f",(((finish.floor_to(15.minutes)-start.floor_to(15.minutes)) / 60)) / 60.0)
  end
end

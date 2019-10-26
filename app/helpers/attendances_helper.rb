module AttendancesHelper
require 'rounding'
  
  def working_times(start,finish)
    format("%.2f",(((finish.floor_to(15.minutes)-start.floor_to(15.minutes)) / 60)) / 60.0)
  end
  
  def attendances_invalid?
    attendances = true
    attendances_params.each do |id,item|
      if item[:worked_on] == Date.today
        next
      elsif item[:started_at].blank? && item[:finished_at].blank?
        next
      elsif item[:started_at] > item[:finished_at]
        attendances = false
        break
      elsif item[:started_at].blank? || item[:finished_at].blank?
        attendances = false
        break
      end
    end
        return attendances
  end
  
  def over_times(estimated,designated)
    format("%.2f",(((estimated.floor_to(15.minutes)-designated.floor_to(15.minutes)) / 60)) / 60.0 )
  end
  
  def next_day_over_times(estimated,designated)
    format("%.2f",24 + (((estimated.floor_to(15.minutes)-designated.floor_to(15.minutes)) / 60)) / 60.0)
  end
  
  def users_have_supporter
     User.all.each do |user|
        user.attendances.any?{|day|(day.supporter.to_i == @user.id)}
      end
   end
end

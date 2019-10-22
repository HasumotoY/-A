class AttendancesController < ApplicationController
include AttendancesHelper
  
  before_action :set_user,only: [:edit_one_month]
  before_action :logged_in_user, only: [:update,:edit_one_month]
  before_action :set_one_month,only: [:edit_one_month]
  before_action :admin_or_correct_user, only: [:update,:edit_one_month]
  
  UPDATE_ERROR_MSG = "登録に失敗しました。やり直してください。"
  
  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    
    if @attendance.started_at.nil?
        if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
          flash[:info] = "おはようございます。"
        else
          flash[:danger]=UPDATE_ERROR_MSG
        end
    elsif @attendance.started_at.present? &&  @attendance.finished_at.nil?
        if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
          flash[:info] = "お疲れ様でした。"  
        else
          flash[:danger]  =UPDATE_ERROR_MSG
        end
    end
    redirect_to @user
  end
  
  def  edit_one_month
  end
  
  def update_one_month
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
      if attendances_invalid? || (@attendance.worked_on == Date.current) && @attendance.update_attributes(attendances_params) 
       flash[:success] = "勤怠変更申請しました。"
       redirect_to @user
      else   
        flash[:danger] = "勤怠変更申請ができませんでした"
        redirect_to attendances_edit_one_month_user_url(date: params[:date])
      end
  end
        
  def work_log
  end
  
  def search
  end
  
  def edit_overtime
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find(params[:id]) 
  end
  
  def update_overtime
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find(params[:id])
      if @attendance.update_attributes(overtime_params) 
        @users = User.all
          @users.each do |user|
            if user.id == @attendance.supporter.to_i
              flash[:success] = "#{user.name}に残業申請しました。"
              redirect_to @user
            end
          end
      else
        flash[:danger] = "残業申請ができませんでした"
        render @user
      end
  end
  
  def notice_approval
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find(params[:id])
  end
  
  def notice_edit_one_month
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find(params[:id])
  end
  
  def notice_overtime
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find(params[:id])
  end
        
  private
    def attendances_params
      params.require(:user).permit(attendances: [:started_at,:finished_at,:note,:worked_on])[:attendances]
    end
    
    def overtime_params
      params.require(:attendance).permit(:end_estimated_time,:next_day,:outline,:supporter)
    end
end

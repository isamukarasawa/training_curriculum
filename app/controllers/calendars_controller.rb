class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def get_week
    @weekdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end
    

      wday_num = @todays_date.wday + x
        if (wday_num >= 7)
          wday_num = (wday_num - 7)
        end
      
      days = { month: (@todays_date + x).month, date: (@todays_date + x).day, plans: today_plans, wday: wdays[ wday_num ]}
      @week_days.push(days)
    end
  end
end

# 5月
    # 10日 金曜日 勉強   今日
    # 11日 土曜日 筋トレ
    # 12日 日曜日 仕事
    # 13日 月曜日 ピアノ
    # 14日 火曜日 読書
    # 15日 水曜日 料理
    # 16日 木曜日 家事

# @todays_date = 10
    # plans = [{id:1,date:10,plan:"勉強"},
    #          {id:2,date:11,plan:"筋トレ"},
    #          {id:3,date:12,plan:"仕事"},
    #          {id:4,date:13,plan:"ピアノ"},
    #          {id:5,date:14,plan:"読書"},
    #          {id:6,date:15,plan:"料理"},
    #          {id:7,date:16,plan:"家事"},]

# times 1回目の繰り返し x = 0
    #   each 一回目
    #     plan = {id:1,date:10,plan:"勉強"}
    #     plan.date == @todays_date + x  は  10 == 10 
    #     today_plans = ["勉強"]
    #   each 二回目
    #     plan = {id:2,date:11,plan:"筋トレ"}
    #     plan.date == @todays_date + x  は  11 == 10 
    #     today_plans = ["勉強"]  のまま
    #   each 三回目
    #     plan = {id:3,date:12,plan:"仕事"}
    #     plan.date == @todays_date + x  は  12 == 10 
    #     today_plans = ["勉強"]  のまま
    #     ...
    #   each 七回目を終えた時
    #   today_plans = ["勉強"] 
    
    #   wday_num = @todays_date.wday + x
    #            = 5 + 0 = 5
    #   days = {:month => May, :date => 10, :plans => ["勉強"],:wday => '(金)'}
    #   @week_days = [{:month => May, :date => 10, :plans => ["勉強"],:wday => '(金)'}]

# times 2回目の繰り返し x = 1
    #   each 一回目
    #     plan = {id:1,date:10,plan:"勉強"}
    #     plan.date == @todays_date + x  は  10 == 11
    #     today_plans = []  のまま
    #   each 二回目
    #     plan = {id:2,date:11,plan:"筋トレ"}
    #     plan.date == @todays_date + x  は  11 == 11 
    #     today_plans = ["筋トレ"]  
    #   each 三回目
    #     plan = {id:3,date:12,plan:"仕事"}
    #     plan.date == @todays_date + x  は  12 == 11
    #     today_plans = ["筋トレ"]  のまま
    #     ...
    #   each 七回目を終えた時
    #   today_plans = ["筋トレ"] 
    
    #   today_plans = ["筋トレ"]
    #   wday_num = @todays_date.wday + x
    #            = 5 + 1 = 6
    #   days = {:month => May, :date => 11, :plans => ["筋トレ"],:wday => '(土)'}
    #   @week_days = [{:month => May, :date => 10, :plans => ["勉強"],:wday => '(金)'},
    #                 {:month => May, :date => 11, :plans => ["筋トレ"],:wday => '(土)'}]

# times 3回目の繰り返し x = 2
    #   each 一回目
    #     plan = {id:1,date:10,plan:"勉強"}
    #     plan.date == @todays_date + x  は  10 == 12
    #     today_plans = []  のまま
    #   each 二回目
    #     plan = {id:2,date:11,plan:"筋トレ"}
    #     plan.date == @todays_date + x  は  11 == 12 
    #     today_plans = []  のまま  
    #   each 三回目
    #     plan = {id:3,date:12,plan:"仕事"}
    #     plan.date == @todays_date + x  は  12 == 12
    #     today_plans = ["仕事"]  
    #     ...
    #   each 七回目を終えた時
    #   today_plans = ["仕事"] 
    #   wday_num = @todays_date.wday + x
    #            = 5 + 2 = 7
    #   wday_num = 0 
    #   days = {:month => May, :date => 11, :plans => ["筋トレ"],:wday => '(日)'}
    #   @week_days = [{:month => May, :date => 10, :plans => ["勉強"],:wday => '(金)'},
    #                 {:month => May, :date => 11, :plans => ["筋トレ"],:wday => '(土)'}、
    #                 {:month => May, :date => 12, :plans => ["仕事"],:wday => '(日)'}]


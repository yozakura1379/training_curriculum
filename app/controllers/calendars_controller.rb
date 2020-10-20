class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_Week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:Calendars).permit(:date, :plan)
  end

  def get_Week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']
 
    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6) #これはdateカラムから@todays_dateで今日から、@todays_date + 6で今日から+６日分まで持ってくる

    7.times do |x|  #Xに0〜6の数字が入り、それが7回繰り返される、
      today_plans = []    #today_plansに配列が入る
      plan = plans.map do |plan|  #このmapはeathと同じ役割、つまり配列の数だけ繰り返す
        today_plans.push(plan.plan) if plan.date == @todays_date + x
#pushは配列の中に入れるという意味     　　plan.planこれが左がブロック変数、その隣がカラム名              plan.date の中から日付だけを取り出す、== @todays_date + xでxが０ならば、つまり日付が今日ならば、左のコードが動く
      end
      wday_num = Date.today.wday #Date.today.wdayで日付から曜日をだけを取り出す
                #Dateメソッドから今日の日付を取り出し、さらにそのなかから曜日を取り出す
      wday_num = wday_num+x #Xは繰り返された番号が入る、2回目なら1、3回目なら２
      if wday_num >= 7
         wday_num = wday_num - 7 #Xを足して７以上なら７引く
      else 
         wday_num
      end

      days = { :month => (@todays_date + x).month, :date => (@todays_date+x).day, :plans => today_plans}      #deaysのなかに各計算式が配列として入っている

      @week_days.push(days)
      #@week_daysにdaysの計算式を入れた   
    end

  end
end

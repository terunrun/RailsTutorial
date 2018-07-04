class StaticPagesController < ApplicationController
  def home
    # 13.3.2 Home画面でマイクロポストを使用できるように関連付け
    # 13.3.3 feedインスタンスを作成
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end

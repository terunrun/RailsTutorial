class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destory]
  before_action :correct_user, only: :destroy

  def create
    # 13.3.2 micropostオブジェクトを作成
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      # 13.3.2 DBへの保存に成功した場合
      flash[:success] = "新しい投稿に成功しました！"
      redirect_to root_url
    else
      # 13.3.2 DBへの保存に失敗した場合
      @feed_items = []
      render 'static_pages/home'
    end
  end

  # 13.3.4
  def destroy
   @micropost.destroy
   flash[:success] = "投稿の削除に成功しました！"
   # 13.3.4 request.referrerで削除を行った画面へ戻る
   # 13.3.4 request.referrerがない場合はホーム画面へ戻る
   redirect_to request.referrer || root_url
  end


  private

    # 13.3.2 contentだけをリクエストとして送信可能にする
    # 13.4.1 picture追加
    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    # 13.3.4 削除前にユーザーに紐づくマイクロポストを取得
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

end

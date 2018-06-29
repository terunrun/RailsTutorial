class AccountActivationsController < ApplicationController

  # 11.3.2
  def edit
    # 11.3.2 URLよりメールアドレスを取得（params[:email]）してユーザーを検索
    user = User.find_by( email: params[:email] )
    # 11.3.2 ユーザーが存在し、未アクティベイト、URLの有効化トークン(params[:id])がダイジェストと一致するか
    if user && !user.activated? && user.authenticated?( :activation, params[:id] )
      # 11.3.2 アクティベート済にしてアクティベート日時を更新
      # 11.3.3 user.rbへリファクタリング
      user.activate
      log_in user
      flash[:success] = "アクティベートが完了しました！"
      redirect_to user
    else
      flash[:danger] = "無効なリンクです。"
      redirect_to root_url
    end
  end
end

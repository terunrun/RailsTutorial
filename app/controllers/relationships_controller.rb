# 14.2.4 新規作成
class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    # 14.2.5 Ajax対応するにはインスタンス変数が必要となる
    # user = User.find(params[:followed_id])
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    # 14.2.5 Ajax対応するためリクエストの形式によって処理を分ける
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end

  def destroy
    # user = Relationship.find(params[:id]).followed
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end
end

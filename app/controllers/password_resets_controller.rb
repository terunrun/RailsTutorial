# 12.1.1
class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_exiration, only: [:edit, :update]

  # 12.1.1
  def new
  end

  # 12.1.3
  def create
    # 12.1.3
    @user = User.find_by( email: params[:password_reset][:email].downcase )
    #
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "パスワード再設定用のメールを送信しました！"
      redirect_to root_url
    else
      flash[:danger] = "入力したメールアドレスが見つかりません。"
      # 12.1.2 renderにしないと情報が残ってしまう？
      render "new"
    end
  end

  # 12.1.1
  def edit
  end

  # 12.3.2
  def update
    if params[:user][:password].empty?
      # 12.3.2 エラーメッセージ(erros)にパスワード(:password)がブランク(:blank)だった時のデフォルトメッセージを格納
      @user.errors.add(:password, :blank)
      render "edit"
    elsif @user.update_attributes(user_params)
      log_in @user
      # 12.3.3 演習；パスワード再設定に成功したら再設定ダイジェストを削除する
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "パスワードの再設定に成功しました！"
      redirect_to @user
    else
      render "edit"
    end
  end


  private

  # 12.3.1 ユーザー取得用メソッド
  def get_user
    @user = User.find_by(email: params[:email])
  end

  # 12.3.1 ユーザーが正しいかを精査
  def valid_user
    unless ( @user && @user.activated? &&
            @user.authenticated?(:reset, params[:id]) )
      redirect_to root_url
    end
  end

  # 12.3.2 パスワード再設定期限が切れていないか確認する
  def check_exiration
    if @user.password_reset_expired?
      message = "パスワード再設定の有効期限が切れています！再度再設定登録を行ってください。"
      flash[:danger] = message
      redirect_to new_password_reset_url
    end
  end

  # 12.3.2 パスワード、確認パスワードのみをアクセス許可にする
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end



end

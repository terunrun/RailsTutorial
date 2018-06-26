class UsersController < ApplicationController
  def show
    #Userをidで検索してインスタンス変数に保存
    @user = User.find(params[:id])
    #debugger
  end

  def new
    #空のuserインスタンスを新規作成
    @user = User.new
  end

  def create
    #formで渡された画面入力値を使用してuserインスタンスを新規作成
    @user = User.new(user_params)
    if @user.save
      #DBへの保存が正常終了した場合
      #一度だけ表示されるメッセージを表示
      flash[:success] = "Sample Appへようこそ！"
      #登録したユーザーのページへリダイレクト
      #redirect_to user_url(@user)と等価
      redirect_to @user
    else
      #DBへの保存が異常終了した場合
      #ユーザー登録画面を表示
      render "new"
    end
  end

  #以下、privateメソッドを記述

  private
    #paramsに設定するパラメータを指定
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                  :password_confirmation)
    end

end

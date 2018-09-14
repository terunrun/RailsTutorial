class UsersController < ApplicationController
  # 10.2.1 10.2.2 10.4.2 edit/updateアクション実行前に実行されるメソッドを定義
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy,:following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  # 10.3.1
  def index
    # 10.3.3 ページネーションが認識できる形式に変更
    # @users = User.all
    # 11.3.3 演習：アクティベート未のユーザーを抽出しない
    # 11.3.3 whereメソッドで絞ったものの中からpaginateオブジェクトを作成
    # @users = User.paginate( page: params[:page])
    @users = User.where( activated: true ).paginate( page: params[:page])
  end

  def show
    # Userをidで検索してインスタンス変数に保存
    @user = User.find(params[:id])
    # 13.2.1 usersコントローラーのコンテキストからmicropostをページネーションするため
    @microposts = @user.microposts.paginate(page: params[:page])
    # 11.3.3 アクティベート未の場合はルート(home)へリダイレクト
    redirect_to root_url and return unless @user.activated?
    #debugger
  end

  def new
    # 空のuserインスタンスを新規作成
    @user = User.new
  end

  def create
    # formで渡された画面入力値を使用してuserインスタンスを新規作成
    @user = User.new(user_params)
    if @user.save
      # DBへの保存が正常終了した場合
      # 8.2.5 ユーザー登録と同時にログインする
      # 11.2.4 アクティベーションの実装により変更
      # log_in(@user)
      # 11.3.3 user.rbへリファクタリング
      @user.send_activation_email
      # 一度だけ表示されるメッセージを表示
      # 11.2.4 アクティベーションの実装により変更
      #flash[:success] = "Sample Appへようこそ！"
      flash[:success] = "ご登録のメールアドレスにアカウント有効化のメールを送信しました！"
      # 登録したユーザーのページへリダイレクト
      # redirect_to user_url(@user)と等価
      # 11.2.4 アクティベーションの実装により変更、root(home)へリダイレクト
      # redirect_to @user
      redirect_to root_url
    else
      # DBへの保存が異常終了した場合
      # ユーザー登録画面を表示
      render "new"
    end
  end

  # 10.1.1
  def edit
    # 10.1.2 編集対象のユーザーを検索して結果を変数に格納
    @user = User.find(params[:id])
  end

  # 10.1.1
  def update
    # 10.1.2 formで渡された画面入力値を使用してDB検索し、結果をインスタンス変数に格納
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報の更新に成功しました！"
      redirect_to @user
    else
      # 10.1.2 更新が失敗した場合
      # 10.1.2 ユーザー編集画面を表示
      render 'edit'
    end
  end

  # 10.4.2
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーの削除に成功しました！"
    redirect_to users_url
  end


  # 10.2.1 以下、beforeアクションを記述

  # 10.2.1
  # 13.3.1 micropostコントローラーでも使用するため、ApplicationControllerへリファクタリング
  # def logged_in_user
  #   # 10.2.1 ログイン済ユーザーかどうかを確認する
  #   unless logged_in?
  #     # 10.2.4 元URLを退避
  #     store_location
  #     flash[:danger] = "ログインしてください！"
  #     # 10.2.1 ログイン画面へリダイレクト
  #     redirect_to login_url
  #   end
  # end

  # 10.2.2
  def correct_user
    @user = User.find(params[:id])
    # 10.2.1 ログイン済ユーザーが正しいかどうかを確認し、正しくない場合はhome(root)へリダイレクト
    redirect_to(root_url) unless current_user?(@user)
  end

  # 14.2.3 フォローしているユーザー一覧表示アクション
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  # 14.2.3 フォロワー一覧表示アクション
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    # followingと表示する内容がほぼ同じのため共通パーシャルとする
    render 'show_follow'
  end

  # 以下、privateメソッドを記述
  private
    # 7.3.2 paramsに設定できるパラメータを指定（Strong parameters）
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                  :password_confirmation)
    end

    # 10.4.2 管理者ユーザーでない場合はhome(root)へリダイレクト
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end

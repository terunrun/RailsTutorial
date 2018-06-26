class SessionsController < ApplicationController
  def new
  end

  def create
    # フォームから送られたメールアドレスでUssersテーブルを検索
    user = User.find_by(email: params[:session][:email].downcase)
    # 検索結果が存在し、フォームから送られたパスワードと一致するかを確認
    if user && user.authenticate(params[:session][:password])
      # 8.2.1 SessionsHelperのlog_inメソッドを使用して一時セッションを作成
      log_in user
      # flashに成功メッセージを設定
      flash[:success] = "ログインに成功しました。"
      # 8.2.1 ログインユーザーの画面へリダイレクト
      # 8.2.1 user_url(user)と等価。引数ユーザーのプロフィールページへのルーティングを作成
      redirect_to user
    else
      # flashに失敗メッセージを設定。一度で消えるようにするためflash.nowを使用。
      flash.now[:danger] = "ログインに失敗しました。
                            メールアドレスまたはパスワードに誤りがあります。"
      # ログイン画面を表示
      render 'new'
    end
  end

  def destroy
    # 8.3 seesions_helper.rbで定義したlogoutメソッドでログアウト
    log_out
    # 8.3 ログアウト後はroot（home）へ遷移
    redirect_to root_url
    #render 'static_pages/home.html.erb'
  end
end

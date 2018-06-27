module SessionsHelper
  # 8.2.1 渡されたユーザーでログインする
  def log_in(user)
    # 8.2.1 一時cookieにuser_idという名前で値を保持
    session[:user_id] = user.id
  end

  # 9.1.2 ログイン状態を保持する
  def remember(user)
    # 9.1.2 Userクラスのrememberメソッドでトークン作成、ハッシュ化してDBへ格納
    user.remember
    # 9.1.2 idを暗号化（signed）して有効期限20年（parmanent）でクッキー（cookies）にuser_idとして保存
    cookies.permanent.signed[:user_id] = user.id
    # 9.1.2 トークンを有効期限20年（parmanent）でクッキー（cookies）にremember_tokenとして保存
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 8.2.2 現在ログイン中のユーザーを返す
  def current_user
    # 9.1.2 一時セッション（session）にuser_idが存在するか
    if ( user_id = session[:user_id] )
      # 8.2.1 現在のユーザーがnilでないなら現在のユーザー、nilならセッションのidでUserを検索
      # @current_user = @current_user || User.find_by(id: session[:user_id])　以下の短縮形で記載
      @current_user ||= User.find_by(id: user_id)
    # 9.1.2 永続セッション（cookies）にuser_idが存在するか
    elsif ( user_id = cookies.signed[:user_id] )
      # 9.3.2 テストが以下のロジックを通っているか確認するため明示的に例外を起こす
      # raise
      # 9.1.2 永続セッションに存在するuser_idでDBを検索してuserに格納
      user = User.find_by(id: user_id)
      # 9.1.2 DBの検索結果が存在し、cookiesのトークンがDBのダイジェストと一致するか
      if user && user.authenticated?(cookies[:remember_token])
        # 9.1.2 DB検索結果ユーザーを現在ログイン中のユーザーとしてログインする
        log_in user
        @current_user == user
      end
    end
  end

  # 8.2.3 ユーザーがログインしていればtrueを返す
  def logged_in?
    # 8.2.3 current_userメソッドの戻りを確認（@current_userそのものを確認しているわけではない。）
    !current_user.nil?
  end

  # 9.1.3 DBのダイジェスト、cookies削除
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 8.2.5 ログアウトメソッド
  def log_out
    # 9.1.3 current_userメソッドで現在ログイン中のユーザーを正してからダイジェスト、cookies削除
    forget(current_user)
    # 渡されたuser_idに紐づくsessionを削除（delete）する
    session.delete(:user_id)
    # 現在ログイン中のユーザー（@current_user）を削除（nilに）する
    @current_user = nil
  end
end

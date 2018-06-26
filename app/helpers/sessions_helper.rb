module SessionsHelper
  # 8.2.1 渡されたユーザーでログインする
  def log_in(user)
    # 8.2.1 一時cookieにuser_idという名前で値を保持
    session[:user_id] = user.id
  end

  # 8.2.2 現在ログイン中のユーザーを返す
  def current_user
      # 8.2.1 現在のユーザーがnilでないなら現在のユーザー、nilならセッションのidでUserを検索
      # @current_user = @current_user || User.find_by(id: session[:user_id])　以下の短縮形で記載
      @current_user ||= User.find_by(id: session[:user_id])
  end

  # 8.2.3 ユーザーがログインしていればtrueを返す
  def logged_in?
    # 8.2.3 current_userメソッドの戻りを確認（@current_userそのものを確認しているわけではない。）
    !current_user.nil?
  end

  # 8.2.5 ログアウトメソッド
  def log_out
    # 渡されたuser_idに紐づくsessionを削除（delete）する
    session.delete(:user_id)
    # 現在ログイン中のユーザー（@current_user）を削除（nilに）する
    @current_user = nil
  end
end

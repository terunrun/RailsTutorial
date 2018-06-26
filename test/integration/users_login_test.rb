require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # 8.2.4 テスト用ユーザーをfixture（user.yml）より設定
  def setup
    @user = users(:michael)
  end

  # 無効なログイン情報でログインし、正しい画面が表示されているかをテスト
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    # ログイン画面へPOSTアクセス、正しい画面が表示されているかをテスト
    post login_path, params: {session: {email: "aa", password: "bb"}}
    assert_template 'sessions/new'
    # flashにメッセージが格納されているかをテスト
    assert_not flash.empty?
    # ホーム画面（ログイン画面以外）へアクセス
    get root_path
    # flashにメッセージが格納されているかをテスト
    assert flash.empty?
  end

  # 8.2.4 有効なログイン情報でログインし、正しい画面が表示されているかをテスト
  test "login with valid information" do
    get login_path
    assert_template 'sessions/new'
    # 8.2.4 ログイン画面へPOSTアクセス、正しい画面が表示されているかをテスト
    post login_path, params: {session: {email: @user.email, password: 'password'}}
    # 8.2.5 登録後ログイン状態になっているかを確認する
    assert is_logged_in?
    # 8.2.4 リダイレクト先が@userに紐づく画面かをテスト
    assert_redirected_to @user
    follow_redirect!
    # 8.2.4 表示された画面が正しいかをテスト
    assert_template 'users/show'
    # 8.2.4 loginリンクが表示されていない(count: 0)かをテスト
    assert_select "a[href=?]", login_path, count: 0
    # 8.2.4 logoutリンク、@userに紐づくProfileリンクが表示されていないかをテスト
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    # 8.3 deleteリクエストをログアウトパスに対して発行
    delete logout_path
    # 8.3 ログイン状態でないことを確認（logged_inメソッドはログアウト済のため使用不可）
    assert_not is_logged_in?
    # 8.3 root（home）へリダイレクトしていることを確認
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end

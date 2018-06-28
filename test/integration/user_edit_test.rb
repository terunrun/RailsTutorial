require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest

  # 10.1.3 ログインユーザーを設定
  def setup
    @user = users(:michael)
  end

  # 10.1.3 無効な入力値での画面描画を確認
  test "edit with invalid information" do
    # 10.2.1 logged_in_user(before_action)に対応するため、ログインする
    log_in_as(@user)
    # 10.1.3 ユーザー編集ページへアクセス
    get edit_user_path(@user)
    # 10.1.3 ユーザー編集ページが表示されているか
    assert_template 'users/edit'
    # 10.1.3 無効な入力値をupdateメソッドへPATCHリクエスト
    patch user_path(@user), params: { user: {name: "",
                                             email: "terunrun@gmail",
                                             password: "12345",
                                             password_confirmation: "23456" } }
    # 10.1.3 ユーザー編集ページが表示されているか
    assert_template 'users/edit'
    # 10.1.3 演習　classがalertのdibタグが1個表示されているか
    assert_select "div.alert", count:1
  end

  # 10.1.4 有効な入力値での画面描画を確認
  test "edit with valid information" do
    # 10.2.1 logged_in_user(before_action)に対応するため、ログインする
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "terunrun"
    email = "terunrun@example.org"
    # 10.1.4 有効な入力値をupdateメソッドへPATCHリクエスト
    patch user_path(@user), params: { user: {name: name,
                                             email: email,
                                             password: "",
                                             password_confirmation: "" }}
    # 10.1.4 flash内にメッセージが格納されているか
    assert_not flash.empty?
    # 10.1.4 ユーザープロフィールへリダイレクトしているか
    assert_redirected_to @user
    # 10.1.4 更新後のDB情報をリロード
    @user.reload
    # 10.1.4 入力と同じ値が表示されているか
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  # 10.2.3 ログイン後、ログイン前URLへリダイレクトしているか
  test "successful edit with friendly fowarding" do
    # 10.2.3 ログイン前にユーザー編集画面へアクセス
    get edit_user_path(@user)
    # 10.2.3 ログイン
    log_in_as(@user)
    # 10.2.3 ログイン後、ユーザー編集画面へリダイレクトされているか
    assert_redirected_to edit_user_url(@user)
    # 10.2.3 演習：ログアウトして再度ログインすると、元URLがリセットされているか
    delete logout_path
    log_in_as(@user)
    assert_equal session[:fowarding_url], nil
    # 10.2.3 編集が正常に完了するか
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: {name: name,
                                             email: email } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

end

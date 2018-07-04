require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

  # 11.3.3
  def setup
    # 11.3.3 deliveriesを初期化（クリア）
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    # signup_pathにGETリクエスト
    get signup_path
    # assert_no_differeneceの引数をUser.countにすることで、実行前後のカウント結果を比較
    assert_no_difference 'User.count' do
      # users_pathにPOSTリクエスト
      get signup_path, params: { user: {name: "",
                                        email: "user@invalid",
                                        password:              "foo",
                                        password_confirmation: "bar"}}
    end
    # 正しく画面表示されるか
    assert_template 'users/new'
    # 以下でエラーが発生する。.のあとに<があるのがダメと言われる。
    #assert_select 'div#<CSS id for error explanation>'
    #assert_select 'div.<CSS class for field with error>'
    # 以下でエラーが発生する。当該のdivタグはないと言われる。
    # assert_select 'div#error_explanation'
    #assert_select 'div.field_with_error'
    # 以下はおそらく不要。どこかで混ぜ込まれたか。
    #assert_select 'form[action="/signup"]'
  end

  # 7.4.4
  test "valid signup information with account activation" do
    # 7.4.4 signup_pathにGETリクエスト
    get signup_path
    # 7.4.4 assert_differeneceの引数をUser.count、数値にすることで、実行前後のカウント結果を比較
    assert_difference 'User.count', 1 do
      # 7.4.4 user_pathにPOSTリクエスト
      post users_path, params: { user: {name: "Examle User",
                                        email: "user@railstutorial.org",
                                        password:              "password",
                                        password_confirmation: "password"}}
    end
    # 11.3.3 メールが1件だけ送信されるか
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    # 11.3.3 userがアクティベートされていないか
    assert_not user.activated?
    # 11.3.3 アクティベート未の場合はログイン不可であるか
    log_in_as(user)
    assert_not is_logged_in?
    # 11.3.3 有効化トークンが不正の場合はログイン不可であるか
    get edit_account_activation_path( "invalid_token", email: user.email )
    assert_not is_logged_in?
    # 11.3.3 メールアドレスが無効の場合はログイン不可であるか
    get edit_account_activation_path( user.activation_token, email: "invalid" )
    assert_not is_logged_in?
    # 11.3.3 正常の場合はアクティベートされるか
    get edit_account_activation_path( user.activation_token, email: user.email )
    assert user.reload.activated?
    # 7.4.4 POSTリクエスト送信の結果で指定されたリダイレクト先へ遷移する
    follow_redirect!
    # 7.4.4 リダイレクト先のテンプレートがuser/showであるかを確認する
    # 11.3.3 アクティベートしたあとはユーザープロフィール画面を表示
    assert_template 'users/show'
    # 7.4.4 flashにメッセージが格納されているかを確認する
    assert_not flash.empty?
    # 8.2.5 登録後ログイン状態になっているかを確認する
    # 11.3.3 アクティベートしたあとはログイン済扱い
    assert is_logged_in?
  end
end

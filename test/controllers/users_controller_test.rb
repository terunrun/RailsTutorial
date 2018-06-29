require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer )
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  # 10.3.1 indexアクションが正しくリダイレクトするか
  test "should rediredt index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  # 10.2.1 egitページへアクセスした際にログインを要求されているか
  # （flashにメッセージが格納されており、ログイン画面へリダイレクトされているか）
  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  # 10.2.1 updateした際にログインを要求されているか
  # （flashにメッセージが格納されており、ログイン画面へリダイレクトされているか）
  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: {name: @user.name,
                                             emai: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  # 10.2.2 間違ったユーザーでログインしている場合のテスト（edit）
  test "should redirect edit when logged in as wrong user" do
    # 10.2.2 間違ったユーザーでログイン
    log_in_as(@other_user)
    # 10.2.2 正しいユーザーの編集画面へ移動
    get edit_user_path(@user)
    # 10.2.2 flashにメッセージが格納されているか
    # 10.2.2 tutorialではassertとしているが、assert_notでないとエラー
    assert_not flash.empty?
    # 10.2.2 home(root)へリダイレクトするか
    assert_redirected_to root_url
  end

  # 10.2.2 間違ったユーザーでログインしている場合のテスト（update）
  test "should redirect update when logged in as wrong user" do
    # 10.2.2 間違ったユーザーでログイン
    log_in_as(@other_user)
    # 10.2.2 正しいユーザーの編集画面へ移動
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    # 10.2.2 flashにメッセージが格納されているか
    # 10.2.2 tutorialではassertとしているが、assert_notでないとエラー
    assert_not flash.empty?
    # 10.2.2 home(root)へリダイレクトするか
    assert_redirected_to root_url
  end

  # 10.4.1 演習
  test "should not allow the admin attribute to be ebited via the web" do
    log_in_as(@other_user)
    # 10.4.1 管理者ユーザーでないか
    assert_not @other_user.admin?
    # 10.4.1 admin属性を変更するPATCHリクエストを送信
    patch user_path(@other_user), params: { user: {password: @other_user.password,
                                            password_confirmation: @other_user.password,
                                            admin: true } }
    # 10.4.1 情報をリロード後も管理者ユーザーでないか
    assert_not @other_user.reload.admin?
  end

  # 10.4.3 ログインしていない状態で削除を行った場合
  test "should redirect destroy when not logged in" do
    # 10.4.3 削除を実行した際にユーザー数が変わっていないか
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    # 10.4.3 ログイン画面へリダイレクトしているか
    assert_redirected_to login_url
  end

  # 10.4.3 ログインしているが、管理者でないユーザーで削除を行った場合
  test "shoule redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    # 10.4.3 root(home画面)へリダイレクトしているか
    assert_redirected_to root_url
  end


end

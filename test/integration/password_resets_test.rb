# 13.3.3
require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  # 12.3.3
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "password resets" do
    # 12.3.3 パスワード再設定メール送信画面が表示されているか
    get new_password_reset_url
    assert_template 'password_resets/new'
    # 12.3.3 無効なメールアドレスの場合、エラーメッセージが表示され、
    # パスワード再設定メール送信画面が表示されているか
    post password_resets_path, params: { password_reset: {email: ""} }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # 12.3.3 有効なメールアドレスの場合、メッセージが表示され、
    # ルート画面が表示されているか
    post password_resets_path, params: { password_reset: {email: @user.email} }
    assert_not flash.empty?
    assert_redirected_to root_url
    # 12.3.3 前後で再設定ダイジェストの値が同じでないか、メールが1件送信されているか
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    # 12.3.3 無効メールアドレスで編集画面へアクセス
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    # 12.3.3 アクティベート未ユーザーで編集画面へアクセス
    # 12.3.3 アクティベート未にする
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    # 12.3.3 アクティベート済にする
    user.toggle!(:activated)
    # 12.3.3 無効再設定トークンで編集画面へアクセス
    get edit_password_reset_path("wrong token", email: user.email)
    assert_redirected_to root_url
    # 12.3.3 有効メールアドレス、再設定トークンで編集画面へアクセス
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    # 12.3.3 name=email、type=hidden、value=user.emailのinputタグが存在するか
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # 12.3.3 無効なパスワードを再設定
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: {password: "abcde", password_confirmation: "fghij"} }
    assert_template 'password_resets/edit'
    assert_select 'div#error_explanation'
    # 12.3.3 空のパスワードを再設定
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: {password: "", password_confirmation: ""} }
    assert_template 'password_resets/edit'
    assert_select 'div#error_explanation'
    # 12.3.3 有効なパスワードを再設定
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: {password: "example", password_confirmation: "example"} }
    assert is_logged_in?
    # 12.3.3 演習：パスワード再設定に成功したら再設定ダイジェストが削除されているか
    assert_nil user.reload.reset_digest
    assert_not flash.empty?
    assert_redirected_to user
  end

  # 12.3.3 演習
  test "expired token" do
    get new_password_reset_path
    post password_resets_path, params: { password_reset: {email: @user.email}}
    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token),
          params: { email: @user.email,
                    user: {password: "example", password_confirmation: "example"} }
    # 12.3.3 ？？？
    assert_response :redirect
    follow_redirect!
    # 12.3.3 返却された画面のbocy部に「expired」という単語が存在するか
    assert_match /expire/i, response.body
  end

end

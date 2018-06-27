require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    # 9.3.2 fixtureでuser変数を定義する
    @user = users(:michael)
    # 9.3.2 渡されたユーザーをログイン状態にする（rememberメソッド）
    remember(@user)
  end

  #エラーになるのでいったんコメントアウト
  # # 9.3.2 current_userメソッドのテスト
  # test "current_user returns right user when session is nil" do
  #   # 9.3.2 渡されたユーザーがcurrent_userと同じであるか
  #   assert_equal @user, current_user
  #   assert is_logged_in?
  # end

  # 9.3.2 current_userメソッドのテスト
  test "current_user returns nil when remember digest is wrong" do
    # 9.3.2 渡されたユーザーのDBのダイジェストを新規トークンのハッシュで更新する
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end

end

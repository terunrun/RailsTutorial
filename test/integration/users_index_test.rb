# 10.3.4 ページネーションのテストで作成
require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end

  # 10.3.4 10.4.3 管理者ユーザー以外の場合のindex画面表示テスト
  test "index as an admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    # 10.3.4 indexページが表示されているか
    assert_template 'users/index'
    # 10.3.4 paginationリンクが存在するか
    assert_select 'div.pagination', count: 2
    # 10.3.4 paginationで1ページ目分取り出したユーザーが表示されているか
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      # 10.4.3 管理者ユーザー以外に対してはdeleteリンクが表示されていないか
      unless user == @admin
        # 10.4.3 href=?の?にuser_path(user)が埋め込まれているか
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    # 10.4.3 deleteを実行した場合にユーザー数が1つ減っているか
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  # 10.4.3 管理者ユーザー以外の場合のindex画面表示テスト
  test "index as an non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'Delete', count: 0
  end

end

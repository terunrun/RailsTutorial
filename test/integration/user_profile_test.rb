# 13.2.3
require 'test_helper'

class UserProfileTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)
    # assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    # 13.2.3 h1タグの内側にgravatarクラス付きのimgタグがあるか
    assert_select 'h1>img.gravatar'
    # 13.2.3 レスポンスのHTMLにmicropostの数が表示されているか
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @user.microposts.paginate(page: 1).each do |micropost|
      # 13.2.3 レスポンスのHTMLに各micropostの内容が表示されているか
      assert_match micropost.content, response.body
    end
  end

end

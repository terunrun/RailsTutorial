# 13.1.1
require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  # 13.1.2
  def setup
    @user = users(:michael)
    # 13.1.3 userを通してmicropostを作成するように変更
    # @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  # 13.1.2 有効チェック
  test "should be valid" do
    assert @micropost.valid?
  end

  # 13.1.2 user_id存在チェック
  test "user_id should be present" do
    # 13.1.2 user_idにnilを代入したときに無効と判断されるか
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  # 13.1.2 cantent存在チェック
  test "content should be present" do
    # 13.1.2 contentにnilを代入したときに無効と判断されるか
    @micropost.content = nil
    assert_not @micropost.valid?
  end

  # 13.1.3 content長さチェック
  test "content should be at most 140 characters" do
    # 13.1.2 contentにaを141文字代入したときに無効と判断されるか
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  # 13.1.4 最新のmicropostから取得されるか
  test "order should be most recent first" do
    # 13.1.4 Fixture内のcreated_atが最新のmicropostオブジェクトがMicropost.firstの結果と等価であるか
    assert_equal microposts(:most_recent), Micropost.first
  end

end

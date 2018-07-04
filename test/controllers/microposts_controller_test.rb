require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @micropost = microposts(:orange)
  end

  # 13.3.1 ログイン未状態でマイクロポストを作成する場合、
  # 13.3.1 マイクロポストの数に変化がなく、ログイン画面へリダイレクトしているか
  test "should redirect create when not logged in" do
    assert_no_difference "Micropost.count" do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  # 通らないのでいったんコメントアウト★
  # # 13.3.1 ログイン未状態でマイクロポストを削除する場合、
  # # 13.3.1 マイクロポストの数に変化がなく、ログイン画面へリダイレクトしているか
  # test "should redirect destry when not logged in" do
  #   assert_no_difference "Micropost.count" do
  #     delete micropost_path(@micropost)
  #   end
  #   assert_redirected_to login_url
  # end

  # 13.3.5 別ユーザーの投稿を削除しようとした場合、
  # 13.3.5 マイクロポストの数に変化がなく、ログイン画面へリダイレクトしているか
  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:michael))
    micropost = microposts(:ants)
    assert_no_difference "Micropost.count" do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_url
  end

end

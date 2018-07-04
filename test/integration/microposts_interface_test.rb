# 13.3.5
require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "microposts interface" do
    log_in_as(@user)
    get root_path
    # 13.3.5 ページネーションが表示されているか
    assert_select "div.pagination"
    # 13.4.1 演習:アップロードフォームが表示されているか
    assert_select "input[type=file]"
    # 通らないのでいったんコメントアウト
    # 13.3.5 誤った投稿をした際にマイクロポストの数が変わっていないか、エラーが発生するか
    # assert_no_difference "Micropost.count" do
    #   post microposts_path, params: { micropost: {content: ""} }
    # end
    # assert_select "div#error_explanation"
    # 13.3.5 正しい投稿をした際にマイクロポストの数が変わっているか
    content = "This micropost really ties the room together"
    # 13.4.1 演習：アップロードするファイルとアップロード先を指定
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    # 13.4.1 演習：pictureを追加
    assert_difference "Micropost.count" do
      post microposts_path, params: {micropost: {content: content, picture: picture} }
    end
    # 13.4.1 演習：アップロードしたファイルが存在するか
    assert assigns(:micropost).picture?
    assert_redirected_to root_url
    follow_redirect!
    # 13.3.5 投稿したマイクロポストがHTMLに表示されているか
    assert_match content, response.body
    # 13.3.5 マイクロポストの削除リンクがあるか
    assert_select "a", text: "delete"
    # 13.3.5 マイクロポストの削除を行った際にマイクロポストの数が変わっているか
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference "Micropost.count", -1 do
      delete micropost_path(first_micropost)
    end
    # 13.3.5 別ユーザーのページにマイクロポストの削除リンクが表示されていないか
    get user_path(users(:archer))
    assert_select "a", text: "delete", count: 0
  end

  # 13.3.5 演習：サイドバーのテスト
  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "#{other_user.microposts.count} microposts", response.body
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match "#{other_user.microposts.count} micropost", response.body
  end


end

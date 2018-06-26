require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  test "invalidn signup information" do
    #signup_pathいGETリクエスト
    get signup_path

    #assert_no_differeneceの引数をUser.countにすることで、実行前後のカウント結果を比較
    assert_no_difference 'User.count' do
      #users_pathにPOSTリクエスト
      get signup_path, params: { user: {name: "",
                                        email: "user@invalid",
                                        password:              "foo",
                                        password_confirmation: "bar"}}
    end
    #正しく画面表示されるか
    assert_template 'users/new'
    #assert_select 'div.<CSS class for field with error>'
    assert_select 'form[action="/signup"]'
  end

  test "validn signup information" do
    #signup_pathいGETリクエスト
    get signup_path
    #assert_differeneceの引数をUser.count、数値にすることで、実行前後のカウント結果を比較
    assert_difference 'User.count', 1 do
      #user_pathにPOSTリクエスト
      post users_path, params: { user: {name: "Examle User",
                                        email: "user@railstutorial.org",
                                        password:              "password",
                                        password_confirmation: "password"}}
    end
    #POSTリクエスト送信の結果で指定されたリダイレクト先へ遷移する
    follow_redirect!
    #リダイレクト先のテンプレートがuser/showであるか
    assert_template 'users/show'
    assert_not flash.empty?
  end
end

require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    # 11.2.3 テストユーザー、有効化トークンを作成
    user = users(:michael)
    user.activation_token = User.new_token
    # mail = UserMailer.account_activation
    mail = UserMailer.account_activation(user)
    # 11.2.3 メールの件名が正しいか
    assert_equal "Account activation", mail.subject
    # 11.2.3 送信先メールアドレスが正しいか
    assert_equal [user.email], mail.to
    # 11.2.3 送信元メールアドレスが正しいか
    assert_equal ["noreply@example.com"], mail.from
    # 11.2.3 デフォルトでは存在するが削除
    #assert_match "Hi", mail.body.encoded
    # 11.2.3 メール本文の文字列がエンコードされているか
    assert_match user.name, mail.body.encoded
    assert_match user.activation_token, mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
  end

  # test "password_reset" do
  #   mail = UserMailer.password_reset
  #   assert_equal "Password reset", mail.subject
  #   assert_equal ["to@example.org"], mail.to
  #   assert_equal ["from@example.com"], mail.from
  #   assert_match "Hi", mail.body.encoded
  # end

end

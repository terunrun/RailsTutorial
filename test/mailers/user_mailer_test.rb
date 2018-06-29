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

  # 12.2.2 テストユーザー、再設定トークンを作成
  test "password_reset" do
    user = users(:michael)
    user.reset_token = User.new_token
    # mail = UserMailer.account_activation
    mail = UserMailer.password_reset(user)
    # 12.2.2 メールの件名が正しいか
    assert_equal "Password reset", mail.subject
    # 12.2.2 送信先メールアドレスが正しいか
    assert_equal [user.email], mail.to
    # 12.2.2 送信元メールアドレスが正しいか
    assert_equal ["noreply@example.com"], mail.from
    # 12.2.2 デフォルトでは存在するが削除
    #assert_match "Hi", mail.body.encoded
    # 12.2.2 メール本文の文字列がエンコードされているか
    assert_match user.reset_token, mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
  end

end

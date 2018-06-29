class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #

  # 11.2.1 メソッドの引数を変更
  #def account_activation
  def account_activation(user)
    # 11.2.1 メールへの埋め込み文字列
    # @greeting = "Hi"

    # 11.2.1 送信先メールアドレス
    #mail to: "to@example.org"
    # 11.2.1 ユーザーのメールアドレスに件名(subject)を設定して送信
    @user = user
    mail to: @user.email, subject: "Account activation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end

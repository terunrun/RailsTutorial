# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    user = User.first
    # 11.2.2 DBは有効化トークン項目を持たないので作成
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    # 12.2.1 DBは有効化トークン項目を持たないので作成
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end

end

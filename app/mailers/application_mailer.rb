class ApplicationMailer < ActionMailer::Base
  # 11.2.1 fromメールアドレスを変更
  #default from: 'from@example.com'
  default from: 'noreply@example.com'
  layout 'mailer'
end

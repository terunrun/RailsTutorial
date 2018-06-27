require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  fixtures :all
  include ApplicationHelper

  # 8.2.5 ユーザーがログインしていればtrueを返す
  def is_logged_in?
    !session[:user_id].nil?
  end

  # 9.3 渡された引数のユーザーとしてログインする
  def log_in_as(user)
    session[:user_id] = user.id
  end
end

class ActionDispatch::IntegrationTest
  # 9.3 渡された引数のユーザーとしてログインする
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                        password: password,
                                        remember_me: remember_me }}
  end
end

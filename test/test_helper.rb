require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper

  # 8.2.5テスト用： ユーザーがログインしていればtrueを返す
  def is_logged_in?
    !session[:user_id].nil?
  end
end

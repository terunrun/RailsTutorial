class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # 8.2 セッション用ヘルパーを全コントローラーで使用可能にする。
  include SessionsHelper

  def hello
    render html: "Hello, world"
  end
end

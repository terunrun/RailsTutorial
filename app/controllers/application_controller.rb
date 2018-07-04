class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # 8.2 セッション用ヘルパーを全コントローラーで使用可能にする。
  include SessionsHelper

  def hello
    render html: "Hello, world"
  end

  private

    # 13.3.1 user、micropostの両コントローラーで使用するため、リファクタリング
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください！"
        redirect_to login_url
      end
    end

end

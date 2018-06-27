class User < ApplicationRecord
  #9.1.1 remember_token属性へのアクセサを定義
  attr_accessor :remember_token

  # DBに保存する直前に処理される。
  before_save { email.downcase! }
  # カラムname、emailに対する精査
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
                    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  # 6.3 セキュアパスワード用メソッドhas_secure_passwordを使用することで、
  # password/password_confirmation属性へのアクセサ、いくつかのバリデーションが与えられる
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}

  # 8.2.4 渡された文字をハッシュ化するクラスメソッド
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # 9.1.1 ランダムなトークンを生成する
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 9.1.1 トークンを作成しDBにハッシュ化して格納する
  def remember
    # 9.1.1 オブジェクト内部変数（self）としてのremember_tokenにトークンの値を格納
    self.remember_token = User.new_token
    # 9.1.1 Usersの他要素の精査を通さないために、update_attributeメソッドを使用して更新
    # 更新にあたり、トークンをハッシュ化する
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 9.1.2 渡されたトークンがダイジェストと一致したらtrueを返す
  # has_secure_passwordで提供されるauthenticatedメソッドを応用
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # 9.1.3 DBのダイジェストを削除する
  def forget
    update_attribute(:remember_digest, nil)
  end

end

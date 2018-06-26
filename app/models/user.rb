class User < ApplicationRecord
  # DBに保存する直前に処理される。
  before_save { email.downcase! }
  # カラムname、emailに対する精査
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
                    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  # セキュアパスワード用メソッド
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}

  # 8.2.4 渡された文字をハッシュ化するクラスメソッド
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end

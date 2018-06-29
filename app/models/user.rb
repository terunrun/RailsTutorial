class User < ApplicationRecord
  #9.1.1 remember_token属性へのアクセサを定義(:activation_tokenは11、:reset_tokenは12.1.2)
  attr_accessor :remember_token, :activation_token, :reset_token

  # 6.2.5 DBに保存(save)する直前に処理される(11.1.2でメソッド参照に変更)
  before_save :downcase_email
  # 11.1.2 ユーザー作成の直前に処理される(メソッド参照)
  before_create :create_activation_digest

  # カラムname、emailに対する精査
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
                    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  # 6.3 セキュアパスワード用メソッドhas_secure_passwordを使用することで、
  # password/password_confirmation属性へのアクセサ、いくつかのバリデーションが与えられる
  # 10.1.4 パスワードが空の時に精査しないallow_nilオプションを追加
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

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
  # 11.3.1 アクティベーションでも使用するため抽象化
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # 9.1.3 DBのダイジェストを削除する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # 11.3.3 有効化済にして有効化日時とともにDBへ格納
  def activate
    # 11.3.3 演習
    #update_attribute( :activated, true )
    #update_attribute( :activated_at, Time.zone.now )
    update_columns( activated: true, activated_at: Time.zone.now )
  end

  # 11.3.3 有効化用のメールを送信
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # 12.1.2 パスワード再設定用のダイジェストを作成してメール送信日時とともにDBへ格納
  def create_reset_digest
    self.reset_token = User.new_token
    # 12.3.3 演習
    #update_attribute(:reset_digest, User.digest(reset_token))
    #update_attribute(:reset_sent_at, Time.zone.now)
    update_columns( reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now )
  end

  # 12.1.2 パスワード再設定用のメールを送信
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # 12.3.2 パスワード再設定メール送信から所定時間が経過しているか
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end


  private

    # 11.1.2 メールアドレスを小文字化する
    def downcase_email
      #self.email = email.downcase
      #11.1.2 演習：メソッド実行結果で元の値を書き換える（破壊的メソッド）
      email.downcase!
    end

    # 11.1.2 アクティベーションダイジェストを作成する
    def create_activation_digest
      # 11.1.2 新規トークンを作成し、オブジェクト内部変数として保存
      self.activation_token = User.new_token
      # 11.1.2 新規トークンをハッシュ化し、オブジェクト内部変数として保存
      self.activation_digest = User.digest(activation_token)
    end

end

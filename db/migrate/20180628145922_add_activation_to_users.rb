# 11.1.1 アクティベーションにて作成
class AddActivationToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :activation_digest, :string
    # 11.1.1 デフォルトでは未アクティベート状態とする
    add_column :users, :activated, :boolean, default: false
    add_column :users, :activated_at, :datetime
  end
end

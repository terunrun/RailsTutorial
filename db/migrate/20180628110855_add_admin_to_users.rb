# 10.4.1 ユーザーの削除で作成
class AddAdminToUsers < ActiveRecord::Migration[5.1]
  def change
    # 10.4.1 defaultをfalseにすることで、デフォルトでは管理者になれないようにする
    add_column :users, :admin, :boolean, default: false
  end
end

# 13.1.
class CreateMicroposts < ActiveRecord::Migration[5.1]
  def change
    create_table :microposts do |t|
      t.text :content
      # 13.1.1 generate時にreferencesを指定することで、外部キーが設定される
      t.references :user, foreign_key: true

      t.timestamps
    end
    # 13.1.1 user_idとcreated_atに複合インデックスを作成
    # 13.1.1 ユーザーごとに作成された順で取得しやすくする
    add_index :microposts, [:user_id, :created_at]
  end
end

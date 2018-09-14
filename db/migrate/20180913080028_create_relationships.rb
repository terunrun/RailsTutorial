class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    # 14.1.1 followed_idとfollowed_idの組み合わせで一意となるよう複合インデックスを作成
    add_index :relationships, [:follower_id, :followed_id], unique: true  end
end

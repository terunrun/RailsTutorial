# 13.1.1
class Micropost < ApplicationRecord
  # 13.1.1 Userと1対1の関係である
  belongs_to :user

  # 13.1.2 user_id、contentのvalidation
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}

  # 13.1.4 取得時の並びを指定（ラムダ式->で記載）
  default_scope -> { order(created_at: :desc) }

  # 13.4.1 画像アップロード
  mount_uploader :picture, PictureUploader

  # 13.4.2 手動で精査を追加
  validate :picture_size


  private

    # アップロード画像のサイズを精査する
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "ファイルサイズが大きすぎます！5メガバイト以下のファイルを選択してください。")
      end
    end

end

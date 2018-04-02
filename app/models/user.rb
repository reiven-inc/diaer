class User < ApplicationRecord
  has_many :articles
  has_many :saves, dependent: :destroy
  has_many :saved_articles, through: :saves, source: 'article'
  has_many :account_image_favorites, dependent: :destroy
  has_many :account_images, through: :account_image_favorites
  has_many :notice_reads, dependent: :destroy
  has_many :read_notices, through: :notice_reads, source: 'notice'
  has_many :notices
  has_many :videos
  has_many :video_favorites
  has_many :favorite_videos, through: :video_favorites, source: 'video'
  has_attached_file :user_image,
                    styles: { original: '300x300#' },
                    path: '/:class/:id/:filename',
                    default_url: "#{CDN_IMAGE_ROOT}/:class/user_default.png"
  has_attached_file :background_image,
                    styles: { original: '750x450#' },
                    path: '/:class/:id/bg/:filename',
                    default_url: "#{CDN_IMAGE_ROOT}/:class/user_bg_default.jpg"
  validates_attachment :user_image, content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] }
  validates_attachment :background_image, content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] }
  validates :user_name,
            presence: { message: 'ユーザー名を入力してください。' },
            length: { maximum: MAX_CHAR_USER_NAME, message: "ユーザー名は#{MAX_CHAR_USER_NAME}文字以内で入力してください。", allow_blank: true },
            uniqueness: { message: '既に同じユーザー名が登録されています。', allow_blank: true }
  validates :user_profile,
            length: { maximum: MAX_CHAR_USER_PROFILE, message: "プロフィールは#{MAX_CHAR_USER_PROFILE}字以内で入力して下さい。", allow_blank: true }
  validates :user_mail,
            presence: { message: 'メールアドレスを入力してください。' },
            format: { with: /\A([a-zA-Z0-9])+([a-zA-Z0-9\._-])*@([a-zA-Z0-9_-])+([a-zA-Z0-9\._-]+)\z/, message: '正しいメールアドレスを入力してください。', allow_blank: true },
            uniqueness: { message: '既に同じメールアドレスが登録されています。', allow_blank: true }
  validates :user_password,
            presence: { message: 'パスワードを入力してください。' },
            length: { minimum: MIN_CHAR_USER_PASSWORD, message: "パスワードは#{MIN_CHAR_USER_PASSWORD}文字以上で入力してください。", allow_blank: true }
  validates_confirmation_of :user_password, message: '2つのパスワードが一致しません。'
end

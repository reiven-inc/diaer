class Articlecontent < ApplicationRecord
  has_one    :tweet, dependent: :destroy
  has_one    :articlecontent_account_image, dependent: :destroy
  has_one    :account_image, through: :articlecontent_account_image
  belongs_to :article
  has_attached_file :paragraph_image,
                    styles: { original: '768x768>' },
                    path: '/:class/:id/:filename',
                    default_url: "#{CDN_IMAGE_ROOT}/articles/image_default.png"
  validates_attachment :paragraph_image,
                       content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] }
  validates :paragraph_title,
            length: { maximum: MAX_CHAR_PARAGRAPH_TITLE, message: "見出しは#{MAX_CHAR_PARAGRAPH_TITLE}文字以内で入力してください", allow_blank: true,
                      if: proc { content_type == HEADLINE_CONTENT_TYPE || content_type == SUBHEAD_CONTENT_TYPE } }
  validates_length_of :words_in_text,
                      maximum: MAX_CHAR_PARAGRAPH_TEXT,
                      message: "引用は#{MAX_CHAR_PARAGRAPH_TEXT}文字以内で入力してください", allow_blank: true,
                      if: proc { content_type == QUOTATION_CONTENT_TYPE }
  validates :link_name,
            length: { maximum: MAX_CHAR_LINK_NAME, message: "リンクのサイト名は#{MAX_CHAR_LINK_NAME}文字以内で入力してください", allow_blank: true }
  validates :link_url,
            format: { with: /\A#{URI.regexp(%w[http https])}\z/, message: 'URLの形式が正しくありません。', allow_blank: true }
  validate :validate_image_rights, :validate_quotation_rights

  def text_size_without_line
    paragraph_text.gsub(/[\r\n]/, '').size
  end

  def output_image_url
    return '' unless content_type == IMAGE_CONTENT_TYPE
    if image_type == LINK_IMAGE_IMAGE_TYPE
      link_url
    else
      paragraph_image.url
    end
  end

  private

    def words_in_text
      paragraph_text.gsub(/[\r\n]/, '').split(//)
    end
end

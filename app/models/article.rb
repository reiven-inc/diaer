class Article < ApplicationRecord
  has_many :article_keywords
  has_many :keywords, through: :article_keywords
  has_many :articlecontents
  has_many :modify_orders
  has_many :saves
  has_many :saved_users, through: :saves, source: 'user'
  has_many :questions, dependent: :destroy
  has_many :question_results, dependent: :destroy
  belongs_to :account_image, optional: true
  belongs_to :category, optional: true
  belongs_to :user
  has_attached_file :article_image,
                    styles: { original: '750x420#', thumb: '200x200#' },
                    path: '/:class/:id/:style/:filename',
                    default_url: "#{CDN_IMAGE_ROOT}/:class/image_default.png"
  counter_culture :user
  before_update :delete_description_line
  validates_attachment :article_image, content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] }
  validates :article_title,
            length: { maximum: MAX_CHAR_ARTICLE_TITLE, message: "タイトルは#{MAX_CHAR_ARTICLE_TITLE}文字以内で入力してください", allow_blank: true }
  validates_length_of :description_without_line,
                      maximum: MAX_CHAR_ARTICLE_DESCRIPTION,
                      message: "タイトルの説明は#{MAX_CHAR_ARTICLE_DESCRIPTION}文字以内で入力してください",
                      allow_blank: true,
                      on: :update
  validate :validate_image_rights, on: :update
  scope :published, -> { where(article_status: PUBLISH_ARTICLE_STATUS) }
  scope :pended, -> { where(article_status: PENDING_ARTICLE_STATUS) }

  def self.search_from_url(url)
    begin
      domain = Addressable::URI.parse(url).domain
    rescue StandardError
      return none
    end
    return none if domain.blank?

    article_image_match_set = where('image_from LIKE ?', "%#{domain}%").pluck(:id)
    articlecontent_image_match_set = Articlecontent.where('content_type = ? AND image_from LIKE ?', IMAGE_CONTENT_TYPE, "%#{domain}%").pluck(:article_id)
    articlecontent_quotation_match_set = Articlecontent.where('content_type = ? AND link_url LIKE ?', QUOTATION_CONTENT_TYPE, "%#{domain}%").pluck(:article_id)
    id_array = article_image_match_set | articlecontent_image_match_set | articlecontent_quotation_match_set
    where(id: id_array).order(:id)
  end

  def destroy_with_related_record
    transaction do
      saves.destroy_all
      article_keywords.each do |ak|
        keyword = ak.keyword
        ak.destroy!
        keyword.destroy! unless keyword.related_object?
      end
      articlecontents.destroy_all
      destroy!
    end
  end

  def output_image_url(size = :original)
    if account_image_id?
      account_image ? account_image.image.url(size) : article_image.url(size)
    elsif image_url?
      image_url
    else
      article_image.url(size)
    end
  end

  def editing_image
    if !(article_image? || image_from? || image_url? || account_image_id?)
      article_image.url
    elsif account_image_id
      account_image ? account_image.image.url(:thumb) : article_image.url
    elsif image_url?
      image_url
    else
      "#{IMAGE_ROOT}#{article_image.path(:thumb)}?#{Time.current.strftime('%Y%m%d%H%M%S')}"
    end
  end

  private

    def delete_description_line
      article_description.gsub!(/[\r\n]/, '')
    end

    def description_without_line
      article_description.gsub(/[\r\n]/, '').split(//)
    end
end

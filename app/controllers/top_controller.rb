class TopController < ApplicationController
  before_action :set_variant, only: [:index]
  before_action :get_ranking, :side_contents, only: %i[index]

  def index
    pickup_articles = Article.includes(:user).where(article_status: PUBLISH_ARTICLE_STATUS, is_pickup: true).where('pickup_at < ?', Date.tomorrow.to_s).order(pickup_at: :desc)
    @main = pickup_articles.limit(3)
    @pickups = pickup_articles.page(params[:page]).per(20)
  end

  def feed
    @articles = Article.select(:id, :article_title, :article_description, :checkpoint).published.order(checkpoint: :desc).limit(30)
    render formats: [:atom]
  end
end

require 'net/http'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  before_action :current_user
  before_action :default_content_mode
  rescue_from ActionController::RoutingError, ActiveRecord::RecordNotFound, with: :http404 unless Rails.env.development?

  def http404
    render file: Rails.root.join('public', '404.html'), status: 404
  end

  private

    def default_content_mode
      @content_mode ||= :article
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def check_login
      redirect_to '/' unless @current_user
    end

    def check_logout
      redirect_to '/' if @current_user
    end

    def side_contents
      side_articles = Article.includes(:user).published
      @andmores = side_articles.where(user_id: OFFICIAL_ACCOUNT_ID).order(checkpoint: :desc).limit(5)
      @news = side_articles.order(checkpoint: :desc).limit(5)
    end

    def set_variant
      request.variant = :mobile if request.user_agent =~ /Mobile|Android/
    end

    def no_cache
      response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, max-age=0, pre-check=0, post-check=0'
    end

    def delete4bytechar(str)
      str.each_char.select { |c| c.bytes.count < 4 }.join('')
    end
end

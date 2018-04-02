class ArticlesController < ApplicationController
  def index
    @articles = Article.includes(:user).published.order(checkpoint: :desc).page(params[:page]).per(50)
  end

  def show
    render file: Rails.root.join('public', '404.html'), status: 404 and return unless @article.article_status == PUBLISH_ARTICLE_STATUS
    show_article(@article)
  end

  def save
    if @current_user
      set_article
      @save = Save.where(user_id: @current_user.id, article_id: params[:id])
      render 'save_handling'
    else
      session[:referer] = request.url
      respond_to do |format|
        format.js { render js: "window.location = '/login';" }
      end
    end
  end

  def cancel_save
    if @current_user
      Save.where(user_id: @current_user.id, article_id: params[:id]).destroy_all
      set_article
      @save = Save.none
      render 'save_handling'
    else
      session[:referer] = request.url
      respond_to do |format|
        format.js { render js: "window.location = '/login';" }
      end
    end
  end
end

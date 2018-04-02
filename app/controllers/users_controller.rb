class UsersController < ApplicationController
  before_action :check_logout, only: %i[new confirm create]
  before_action :set_user, :side_contents, only: %i[show videos]
  before_action :set_variant, :get_ranking

  def new
    @user = User.new
    session[:user_info] = nil
  end

  def confirm
    @user = User.new(user_params)
    if @user.valid?
      session[:user_info] = user_params
      session[:user_info]['user_password'] = session[:user_info]['user_password_confirmation'] = BCrypt::Password.create(user_params['user_password'])
    else
      render 'new'
    end
  end

  def create
    if session[:user_info].present?
      begin
        @current_user = User.create!(session[:user_info])
        PostMailer.signup_email(@current_user).deliver_now
        session[:user_id] = @current_user.id
      rescue => e
        logger.debug(e)
      end
    end
    session[:user_info] = nil
  end

  def index
    @curators = User.joins(:articles).group(:user_id)
                    .select('users.id, sum(saves_count) AS save_size, count(*) AS article_size, user_name, user_profile, user_image_file_name')
                    .where(user_type: CURATOR_USER_TYPE, articles: { article_status: PUBLISH_ARTICLE_STATUS })
                    .order('save_size DESC, article_size DESC').page(params[:page]).per(30)
  end

  def show
    @articles = @user.articles.published.order(saves_count: :desc).page(params[:page]).per(20)
  end

  private

    def user_params
      params.require(:user).permit(:user_name, :user_mail, :user_password, :user_password_confirmation)
    end

    def set_user
      @user = User.find(params[:id])
      render file: "#{Rails.root}/public/404.html", status: 404 and return unless @user.user_type == CURATOR_USER_TYPE
      side_articles = Article.includes(:user).published
      @andmores = side_articles.where(user_id: OFFICIAL_ACCOUNT_ID).order(checkpoint: :desc).limit(5)
      @news = side_articles.order(checkpoint: :desc).limit(5)
    end
end

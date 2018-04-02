class LoginController < ApplicationController
  before_action :set_variant
  before_action :check_logout, only: %i[index create]
  before_action :get_ranking

  def index; end

  def create
    @alert1 = ''
    @alert2 = ''
    @alert3 = ''
    user = User.find_by(user_mail: params[:mail])
    if !user.nil?
      if BCrypt::Password.new(user.user_password) == params[:pass]
        session[:user_id] = user.id
        session[:referer] = nil
        redirect_to '/'
      else
        if params[:pass].empty?
          @alert2 = '※パスワードを入力してください。'
        else
          @alert3 = '※メールアドレスまたはパスワードが間違っています。'
        end
        render 'index'
      end
    else
      @alert1 = '※メールアドレスを入力してください。' if params[:mail].empty?
      @alert2 = '※パスワードを入力してください。' if params[:pass].empty?
      @alert3 = '※メールアドレスまたはパスワードが間違っています。' if @alert1.empty? && @alert2.empty?
      render 'index'
    end
  end

  def logout
    reset_session
    @current_user = nil
    redirect_to '/'
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_site_setting
  helper_method :current_user, :user_signed_in?, :authenticate_user

  # 記事の公開処理
  def publish
    @article = Article.find(params[:id])
    if @article.update(status: 'published', published_at: Time.current)
      flash[:notice] = '記事が公開されました。'
    else
      flash[:alert] = '記事の公開に失敗しました。'
    end
    redirect_to @article
  end

  private

  # 現在のユーザーを取得
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # ユーザーがログインしているかを確認
  def user_signed_in?
    current_user.present?
  end

  # ログインしていない場合にリダイレクト
  def authenticate_user
    unless user_signed_in?
      flash[:alert] = 'ログインが必要です。'
      redirect_to root_path
    end
  end

  # サイト設定を取得
  def set_site_setting
    @site_setting = SiteSetting.first_or_initialize
  end
end

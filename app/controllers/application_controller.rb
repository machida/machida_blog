class ApplicationController < ActionController::Base
  before_action :restore_flash_from_session
  before_action :set_site_setting
  protect_from_forgery with: :exception

  helper_method :current_user, :user_signed_in?, :authenticate_user

  def publish
    @article = Article.find(params[:id])
    @article.update(status: 'published', published_at: Time.current)
    redirect_to @article
  end

  private

  def restore_flash_from_session
    return unless session[:flash]

    flash.update(session[:flash])
    session.delete(:flash)
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    current_user.present?
  end

  def authenticate_user
    unless user_signed_in?
      store_flash_message(:alert, 'ログインが必要です。')
      redirect_to root_path
    end
  end

  def set_site_setting
    @site_setting = SiteSetting.first_or_initialize
  end

  def store_flash_message(type, message)
    session[:flash] ||= {}
    session[:flash][type] = message
  end
end

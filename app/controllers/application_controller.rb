class ApplicationController < ActionController::Base
  before_action :set_site_setting
  protect_from_forgery with: :exception
  before_action :restore_flash_from_session # フラッシュの復元を先に実行
  before_action :clear_old_sessions
  after_action :discard_flash # レスポンス後にフラッシュを破棄
  helper_method :current_user, :user_signed_in?, :authenticate_user

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

  def clear_old_sessions
    if session[:flash].present?
      Rails.logger.info "Clearing old flash session: #{session[:flash].inspect}"
    end
    session.delete(:flash)  # 古いセッションを削除
  end

  def restore_flash_from_session
    flash_data = session.delete(:flash) # 一度だけ取り出して削除
    if flash_data.is_a?(Hash) && flash_data.any?
      Rails.logger.info "Restoring flash: #{flash_data}"
      flash.update(flash_data)
    end
  end

  def discard_flash
    # 使用済みのフラッシュを次のリクエストに持ち越さないように破棄
    flash.discard
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    current_user.present?
  end

  def authenticate_user
    unless user_signed_in?
      flash[:alert] = 'ログインが必要です。'
      redirect_to root_path
    end
  end

  def set_site_setting
    @site_setting = SiteSetting.first_or_initialize
  end
end

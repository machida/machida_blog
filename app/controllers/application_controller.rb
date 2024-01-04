class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :user_signed_in?, :authenticate_user

  def publish
    @article = Article.find(params[:id])
    @article.update(status: 'published', published_at: Time.current)
    redirect_to @article
  end

  helper_method :current_user, :user_signed_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    current_user.present?
  end

  def authenticate_user
    redirect_to login_path unless user_signed_in?
  end
end

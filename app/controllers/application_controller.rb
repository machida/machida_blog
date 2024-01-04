class ApplicationController < ActionController::Base
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
end

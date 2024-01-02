class ApplicationController < ActionController::Base
  def publish
    @article = Article.find(params[:id])
    @article.update(status: 'published', published_at: Time.current)
    redirect_to @article
  end
end

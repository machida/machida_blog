class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show]
  before_action :authenticate_user, only: %i[drafts]

  # GET /articles or /articles.json
  def index
    @published_articles = Article.where(status: 'published')
                                 .order(published_at: :desc)
                                 .page(params[:page]).per(10)
  end

  # GET /articles/drafts
  def drafts
    @draft_articles = Article.where(status: 'draft')
                             .order(created_at: :desc)
                             .page(params[:page]).per(10)
  end

  # GET /articles/feed.rss
  def feed
    @articles = Article.where(status: 'published')
                       .order(published_at: :desc)
                       .limit(20)
    respond_to do |format|
      format.rss { render layout: false }
    end
  end

  # GET /articles/:id
  def show
  end

  private

  # 共通のセットアップ
  def set_article
    @article = Article.find(params[:id])
  end
end

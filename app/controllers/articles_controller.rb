class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]
  before_action :authenticate_user, only: %i[ new create edit update destroy drafts ]

  # GET /articles or /articles.json
  def index
    @articles = Article.all
    @published_articles = Article.where(status: 'published')
    @unpublished_articles = Article.where(status: 'draft')
  end

  def drafts
    @draft_articles = Article.where(status: 'draft')
  end

  def feed
    @articles = Article.where(status: 'published').order(published_at: :desc).limit(20)
    Rails.logger.info "Feed action called. Articles count: #{@articles.count}"
    respond_to do |format|
      format.rss { render layout: false }
    end
  end

  # GET /articles/1 or /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
    redirect_to articles_path unless @article.user == current_user
  end

  def update
    @article = Article.find(params[:id])
    if @article.user == current_user && @article.update(article_params)
      # 更新処理
    else
      # エラー処理
    end
  end

  # POST /articles or /articles.json
  def create
    @article = current_user.articles.build(article_params)
    set_status_and_published_at

    if @article.save
      if @article.status == 'draft'
        render json: { message: 'Draft saved successfully', id: @article.id }, status: :ok
      else
        redirect_to article_url(@article), notice: '記事を作成しました。'
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    @article = Article.find(params[:id])
    set_status_and_published_at

    if @article.update(article_params)
      if @article.status == 'draft'
        render json: { message: 'Draft updated successfully', id: @article.id }, status: :ok
      else
        redirect_to article_url(@article), notice: '記事を更新しました。'
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    if @article.user == current_user
      @article.destroy
      respond_to do |format|
        format.html { redirect_to articles_url, notice: '記事を削除しました。' }
        format.json { head :no_content }
      end
    else
      # エラー処理
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.find(params[:id])
  end

  def set_status_and_published_at
    if params[:save_as_draft]
      @article.status = 'draft'
    elsif params[:publish]
      @article.status = 'published'
      @article.published_at = Time.current if @article.published_at.blank?
    end
  end

  def article_params
    params.require(:article).permit(:title, :body, :published_at)
  end
end

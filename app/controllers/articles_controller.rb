class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]
  before_action :authenticate_user, only: %i[ new create edit update destroy drafts ]

  # GET /articles or /articles.json
  def index
    @published_articles = Article.where(status: 'published').order("published_at DESC").page(params[:page]).per(10)
  end

  def drafts
    @draft_articles = Article.where(status: 'draft').order("created_at DESC").page(params[:page]).per(1)
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

  # POST /articles or /articles.json
  def create
    @article = current_user.articles.build(article_params)
    set_status

    if @article.save
      redirect_after_save
    else
      Rails.logger.debug "Article Creation Failed: #{@article.errors.full_messages.join(", ")}"
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    @article = Article.find(params[:id])
    set_status

    if @article.update(article_params)
      redirect_after_save
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

  def set_status
    if params[:save_as_draft]
      @article.status = 'draft'
    elsif params[:publish]
      @article.status = 'published'
    end
  end

  def redirect_after_save
    if @article.status == 'draft'
      render json: { message: '記事が下書きとして保存されました。', id: @article.id }, status: :ok
    else
      # 以前の状態をチェックして適切なメッセージを表示
      if @article.previous_changes.include?('status') && @article.previous_changes['status'].first == 'draft'
        # 下書きから公開への変更
        redirect_to article_url(@article), notice: '記事を公開しました。'
      else
        # 既に公開されている記事の更新
        redirect_to article_url(@article), notice: '記事を更新しました。'
      end
    end
  end

  def article_params
    params.require(:article).permit(:title, :body, :id, :published_at, :status, :user_id).tap do |permitted_params|
      if params[:publish] && permitted_params[:published_at].blank?
        permitted_params[:published_at] = Time.current
      end
    end
  end
end

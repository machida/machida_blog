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
    set_status

    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(@article), notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    @article = Article.find(params[:id])
    set_status

    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @article = Article.find(params[:id])
    if @article.user == current_user
      @article.destroy
      respond_to do |format|
        format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      # エラー処理
    end
  end

  private
    def authenticate_user
      redirect_to login_path unless user_signed_in?
    end

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

    def article_params
      params.require(:article).permit(:title, :body, :published_at)
    end
end

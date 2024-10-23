module Dashboard
  class ArticlesController < ApplicationController
    before_action :authenticate_user
    before_action :set_article, only: [:edit, :update, :destroy]

    def index
      if params[:status] == 'draft'
        @draft_articles = current_user.articles.where(status: 'draft').order(created_at: :desc).page(params[:page]).per(10)
      else
        @articles = current_user.articles.where(status: 'published').order(published_at: :desc).page(params[:page]).per(10)
      end
    end

    def new
      @article = Article.new
    end

    def create
      @article = current_user.articles.build(article_params)
      set_status

      if @article.save
        redirect_after_save
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      redirect_to dashboard_articles_path unless @article.user == current_user
    end

    def update
      set_status

      if @article.update(article_params)
        redirect_after_save
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @article.user == current_user
        @article.destroy
        redirect_to dashboard_articles_path, notice: '記事を削除しました。'
      else
        redirect_to dashboard_articles_path, alert: '他のユーザーの記事を削除することはできません。'
      end
    end

    private

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
        redirect_to dashboard_articles_path(status: 'draft'), notice: '記事が下書きとして保存されました。'
      else
        redirect_to article_path(@article), notice: '記事を公開しました。'
      end
    end

    def article_params
      params.require(:article).permit(:title, :body, :thumbnail, :meta_description, :published_at, :status)
    end
  end
end

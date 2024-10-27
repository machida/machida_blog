module Dashboard
  class ArticlesController < ApplicationController
    include ActionView::RecordIdentifier

    before_action :authenticate_user
    before_action :set_article, only: [:edit, :update, :destroy]

    def index
      if params[:status] == 'draft'
        @draft_articles = current_user.articles.where(status: 'draft').order(created_at: :desc).page(params[:page]).per(10)
      else
        @articles = current_user.articles.where(status: 'published').order(published_at: :desc).page(params[:page]).per(10)
      end
    end

    def show
      redirect_to edit_dashboard_article_path(params[:id])
    end

    def new
      @article = Article.new
    end

    def create
      @article = current_user.articles.build(article_params)
      set_status_and_published_at(@article) # 状態を設定

      if @article.save
        redirect_after_save(@article)
      else
        flash.now[:alert] = @article.errors.full_messages
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      redirect_to dashboard_articles_path unless @article.user == current_user
    end

    def update
      set_status_and_published_at(@article) # 更新前に状態を設定

      if @article.update(article_params)
        redirect_after_save(@article)
      else
        # エラーメッセージを表示
        Rails.logger.info "Validation failed: #{@article.errors.full_messages.join(', ')}"
        flash.now[:alert] = @article.errors.full_messages
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @article.user == current_user && @article.destroy
        flash[:notice] = '記事を削除しました。'
        redirect_to dashboard_articles_path(status: 'draft')
      else
        flash[:alert] = '他のユーザーの記事を削除することはできません。'
        redirect_to dashboard_articles_path(status: 'draft')
      end
    end

    private

    def set_article
      @article = Article.find_by(id: params[:id])
      unless @article
        flash[:alert] = '記事が見つかりません。'
        redirect_to dashboard_articles_path(status: 'draft')
      end
    end

    def set_status_and_published_at(article)
      if params[:publish]
        article.status = 'published'
        article.published_at ||= Time.current # 未設定なら現在時刻
      elsif params[:save_as_draft]
        article.status = 'draft'
        article.published_at = nil # 下書きは公開日をリセット
      end
    end

    def redirect_after_save(article)
      respond_to do |format|
        format.html do
          if article.status == 'draft'
            flash[:notice] = '記事が下書きとして保存されました。'
            redirect_to dashboard_articles_path(status: 'draft')
          else
            flash[:notice] = '記事を公開しました。'
            redirect_to article_path(article)
          end
        end

        format.turbo_stream do
          flash.now[:notice] = article.status == 'draft' ? '記事が下書きとして保存されました。' : '記事を公開しました。'
          render turbo_stream: turbo_stream.replace('flash', partial: 'shared/flash')
        end
      end
    end

    def article_params
      params.require(:article).permit(:title, :body, :thumbnail, :meta_description, :published_at, :status)
    end
  end
end

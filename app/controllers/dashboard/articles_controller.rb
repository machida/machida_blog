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
      set_status_and_published_at

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
      if @article.update(article_params)
        set_status_and_published_at
        redirect_after_save
      else
        # エラーメッセージをログとフラッシュに表示
        Rails.logger.info "Validation failed: #{@article.errors.full_messages.join(', ')}"
        flash.now[:alert] = @article.errors.full_messages.to_sentence

        # オブジェクトの状態を正しく保持して再レンダリング
        @article.reload if @article.persisted? # リロードすることで、破損した状態を修正

        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @article.user == current_user && @article.destroy
        respond_to do |format|
          format.html do
            flash[:notice] = '記事を削除しました。'
            redirect_to dashboard_articles_path(status: 'draft')
          end
          format.turbo_stream do
            render turbo_stream: turbo_stream.append('flash', partial: 'shared/flash', locals: { notice: '記事を削除しました。' }) + turbo_stream.redirect_to(dashboard_articles_path(status: 'draft'))
          end
        end
      else
        respond_to do |format|
          format.html do
            redirect_to dashboard_articles_path(status: 'draft'), alert: '他のユーザーの記事を削除することはできません。'
          end
          format.turbo_stream do
            render turbo_stream: turbo_stream.append('flash', partial: 'shared/flash', locals: { alert: '他のユーザーの記事を削除することはできません。' })
          end
        end
      end
    end

    private

    def set_article
      @article = Article.find_by(id: params[:id])
      if @article.nil?
        respond_to do |format|
          format.html do
            redirect_to dashboard_articles_path(status: 'draft'), alert: '記事が見つかりません。'
          end
          format.turbo_stream do
            flash.now[:alert] = '記事が見つかりません。'
            render turbo_stream: turbo_stream.replace('flash', partial: 'shared/flash')
          end
        end
      end
    end

    def set_status_and_published_at
      if params[:publish]
        @article.status = 'published'
        @article.published_at ||= Time.current # 公開日時が空なら現在の日時を設定
      elsif params[:save_as_draft]
        @article.status = 'draft'
        @article.published_at = nil # 下書きの場合は公開日をリセット
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

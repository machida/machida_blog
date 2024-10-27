class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show]
  before_action :authenticate_user_for_draft!, only: %i[show]

  # 公開記事の一覧を表示
  def index
    @published_articles = Article.where(status: 'published')
                                 .order(published_at: :desc)
                                 .page(params[:page]).per(10)
  end

  # RSSフィードを提供
  def feed
    @articles = Article.where(status: 'published')
                       .order(published_at: :desc)
                       .limit(20)
    respond_to do |format|
      format.rss { render layout: false }
    end
  end

  # 記事の詳細を表示
  def show; end

  private

  # 下書き記事へのアクセスを制限するメソッド
  def authenticate_user_for_draft!
    if @article.status == 'draft'
      if !user_signed_in?
        flash[:alert] = '記事が見つかりません。'
        redirect_to root_path
      elsif @article.user != current_user
        flash[:alert] = '他のユーザーの下書き記事にはアクセスできません。'
        redirect_to root_path
      end
    end
  end

  # 現在のユーザーを取得
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # ユーザーがログインしているかどうかの確認
  def user_signed_in?
    current_user.present?
  end

  # 記事をセットアップする共通メソッド
  def set_article
    @article = Article.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = '記事が見つかりません。'
    redirect_to root_path
  end
end

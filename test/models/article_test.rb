require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @article = @user.articles.build(title: "有効なタイトル", body: "有効な本文", status: 'draft')
  end

  test "有効なArticleオブジェクト" do
    assert @article.valid?
  end

  test "titleが空の場合は無効" do
    @article.title = ""
    assert_not @article.valid?
  end

  test "bodyが空の場合は無効" do
    @article.body = ""
    assert_not @article.valid?
  end
end

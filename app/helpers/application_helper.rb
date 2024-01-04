module ApplicationHelper
  def published?(article)
    article.status == 'published'
  end

  def draft?(article)
    article.status == 'draft'
  end
end

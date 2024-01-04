module ApplicationHelper
  def site_title
    SiteSetting.first.site_title
  end

  def published?(article)
    article.status == 'published'
  end

  def draft?(article)
    article.status == 'draft'
  end

  private
end

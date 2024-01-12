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

  def format_rfc822(datetime)
    datetime.strftime("%a, %d %b %Y %H:%M:%S %z")
  end

  private
end

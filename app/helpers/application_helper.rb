module ApplicationHelper
  def site_title
    SiteSetting.first.site_title
  end

  def site_description
    SiteSetting.first.site_description
  end

  def site_meta_description
    SiteSetting.first.site_meta_description
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

  def display_copyright(site_setting)
    site_setting.copyright.present? ? site_setting.copyright : site_setting.site_title
  end

    private
end

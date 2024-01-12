xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "#{site_title} #{@articles.first.published_at}"
    xml.description "Your Blog Description"
    xml.link articles_url

    if @articles.present?
      @articles.each do |article|
        xml.item do
          xml.title article.title
          xml.description markdown_renderer.render(article.body).html_safe
          xml.pubDate format_rfc822(article.published_at) if article.published_at.present?
          xml.link article_url(article)
          xml.guid article_url(article)
        end
      end
    end
  end
end

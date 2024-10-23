xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "#{site_title} #{@articles.first.published_at.strftime('%Y-%m-%d %H:%M:%S')}"
    xml.description "#{site_description}"
    xml.link articles_url

    @articles.each do |article|
      xml.item do
        xml.title article.title

        # 本文のHTMLをCDATAで包んでエスケープを防ぐ
        body = markdown_renderer.render(article.body).html_safe
        xml.description { xml.cdata! body }

        # 公開日時
        xml.pubDate article.published_at.strftime('%a, %d %b %Y %H:%M:%S %z')

        # 記事へのリンク
        xml.link article_url(article)

        # GUIDの設定
        xml.guid article_url(article), isPermaLink: true
      end
    end
  end
end

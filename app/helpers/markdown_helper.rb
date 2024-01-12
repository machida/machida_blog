module MarkdownHelper
  def markdown_renderer
    Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end
end

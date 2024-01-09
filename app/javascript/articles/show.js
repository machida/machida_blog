// Markdown-itのインスタンスを作成
const md = markdownit({
  html: true,
  xhtmlOut: false,
  breaks: true,
  langPrefix: 'language-',
  linkify: true,
  typographer: true,
  quotes: '“”‘’',
  highlight: function () { return ''; }
});
md.use(window.markdownitEmoji);

// '.markdown2html'クラスを持つ要素を取得し、MarkdownからHTMLに変換
document.querySelectorAll('.markdown2html').forEach(element => {
  // 'loaded'クラスを追加して、'読み込み中...'の表示を消す
  element.classList.add('loaded');
  const originalText = element.textContent;
  const html = md.render(originalText);
  element.innerHTML = html;
});

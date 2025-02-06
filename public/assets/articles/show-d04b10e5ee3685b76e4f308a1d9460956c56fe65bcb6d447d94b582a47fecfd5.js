// Markdown-itのインスタンスを作成
const md = markdownit({
  html: true /*not default*/ ,
  xhtmlOut: false,
  breaks: true /*not default*/ ,
  langPrefix: 'language-',
  linkify: true /*not default*/ ,
  typographer: true /*not default*/ ,
  quotes: '“”‘’',
  highlight: function (str, lang) {
    if (lang && Prism.languages[lang]) {
      try {
        return '<pre class="line-numbers language-' + lang + '"><code>' +
          Prism.highlight(str, Prism.languages[lang], lang) +
          '</code></pre>';
      } catch (__) {}
    }

    return '<pre class="line-numbers language-none"><code>' + md.utils.escapeHtml(str) + '</code></pre>';
  }
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

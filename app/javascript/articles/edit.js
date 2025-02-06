const csrfToken = document.querySelector('[name="csrf-token"]').content;
const titleInput = document.getElementById('article_title');
const titlePreview = document.getElementById('title-preview');
const textarea = document.getElementById('markdown-input');
const preview = document.getElementById('markdown-preview');

import { updateTitlePreview, updateMarkdownPreview, autoResizeTextarea } from './markdownSetup';
import { handleDragOver, handleDrop, handlePaste } from './imageUpload';

// Markdown-It の初期化
const md = markdownit({
  html: true,
  xhtmlOut: false,
  breaks: true,
  langPrefix: 'language-',
  linkify: true,
  typographer: true,
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

// イベントリスナーの設定
document.addEventListener("turbo:load", function() {
  updateTitlePreview(titleInput, titlePreview);
  updateMarkdownPreview(textarea, preview, md);
  autoResizeTextarea(textarea);
  Prism.highlightAll();
});

titleInput.addEventListener('input', function() {
  updateTitlePreview(titleInput, titlePreview);
});

textarea.addEventListener('input', function() {
  updateMarkdownPreview(textarea, preview, md);
  autoResizeTextarea(textarea);
  Prism.highlightAll();
});

textarea.addEventListener('dragover', handleDragOver, false);

textarea.addEventListener('drop', (event) => {
  handleDrop(event, textarea, csrfToken, () => {
      updateMarkdownPreview(textarea, preview, md);
  });
}, false);

textarea.addEventListener('paste', (event) => {
  handlePaste(event, textarea, csrfToken, () => {
    updateMarkdownPreview(textarea, preview, md);
  });
});

const csrfToken = document.querySelector('[name="csrf-token"]').content;
const titleInput = document.getElementById('article_title');
const titlePreview = document.getElementById('title-preview');
const textarea = document.getElementById('markdown-input');
const preview = document.getElementById('markdown-preview');
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

document.addEventListener("turbo:load", function() {
  updateTitlePreview();
  updateMarkdownPreview();
  autoResizeTextarea();
  Prism.highlightAll();
});

titleInput.addEventListener('input', function() {
  updateTitlePreview();
});

function updateTitlePreview() {
  titlePreview.textContent = titleInput.value;
}

textarea.addEventListener('input', function() {
  updateMarkdownPreview();
  autoResizeTextarea();
  Prism.highlightAll();
});

function updateMarkdownPreview() {
  const html = md.render(textarea.value);
  preview.innerHTML = html;
}

function autoResizeTextarea() {
  textarea.style.height = 'auto';
  textarea.style.height = (textarea.scrollHeight) + 'px';
}

textarea.addEventListener('dragover', handleDragOver, false);
textarea.addEventListener('drop', handleDrop, false);

function handleDragOver(event) {
  event.stopPropagation();
  event.preventDefault();
  event.dataTransfer.dropEffect = 'copy';
}

function handleDrop(event) {
  event.stopPropagation();
  event.preventDefault();

  const files = event.dataTransfer.files;

  if (files.length > 0) {
    const file = files[0];
    if (file.type.match('image.*')) {
      insertTextAtCursor(textarea, 'アップロード中...');
      uploadImage(file);
    }
  }
}

function uploadImage(file) {
  const formData = new FormData();
  formData.append('file', file);

  fetch('/images', {
    method: 'POST',
    headers: {
      'X-CSRF-Token': csrfToken
    },
    body: formData
  })
  .then(response => {
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    return response.json();
  })
  .then(data => {
    replaceTextAtPosition(textarea, 'アップロード中...', `![画像](${data.url})\n`);
    updateMarkdownPreview();
  })
  .catch(error => console.error('There has been a problem with your fetch operation:', error));
}

function insertTextAtCursor(textarea, text) {
  const startPos = textarea.selectionStart;
  const endPos = textarea.selectionEnd;
  const beforeText = textarea.value.substring(0, startPos);
  const afterText = textarea.value.substring(endPos);

  textarea.value = beforeText + text + afterText;
  textarea.selectionStart = textarea.selectionEnd = startPos + text.length;
}

function replaceTextAtPosition(textarea, originalText, newText) {
  const text = textarea.value;
  const position = text.indexOf(originalText);
  if (position !== -1) {
    textarea.value = text.slice(0, position) + newText + text.slice(position + originalText.length);
  }
};

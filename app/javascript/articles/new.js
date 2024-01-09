import 'markdownit';
import 'markdown-it-emoji';

const textarea = document.getElementById('markdown-input');
const preview = document.getElementById('markdown-preview');
const md = markdownit({
  html: true /*not default*/,
  xhtmlOut: false,
  breaks: true /*not default*/,
  langPrefix: 'language-',
  linkify: true /*not default*/,
  typographer: true /*not default*/,
  quotes: '“”‘’',
  highlight: function (/*str, lang*/) { return ''; }
});

md.use(window.markdownitEmoji);

textarea.addEventListener('input', function() {
  updateMarkdownPreview();
  autoResizeTextarea();
});

function updateMarkdownPreview() {
  // Convert the Markdown text to HTML
  const html = md.render(textarea.value);
  // Set the HTML content of the preview element
  preview.innerHTML = html;
}

// テキストエリアの高さを自動調整する関数
function autoResizeTextarea() {
    textarea.style.height = 'auto';
    textarea.style.height = (textarea.scrollHeight) + 'px';
}

textarea.addEventListener('dragover', handleDragOver, false);
textarea.addEventListener('drop', handleDrop, false);

function handleDragOver(event) {
  event.stopPropagation();
  event.preventDefault();
  event.dataTransfer.dropEffect = 'copy'; // Explicitly show this is a copy.
}

function handleDrop(event) {
  event.stopPropagation();
  event.preventDefault();

  const files = event.dataTransfer.files; // ドロップされたファイルを取得

  if (files.length > 0) {
    const file = files[0];
    if (file.type.match('image.*')) {
      uploadImage(file); // 画像をアップロードする関数
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
    insertImageUrlToTextarea(data.url);
  })
  .catch(error => console.error('There has been a problem with your fetch operation:', error));
}

function insertImageUrlToTextarea(url) {
  const markdownImageText = `![画像](${url})\n`;
  textarea.value += markdownImageText;
  updateMarkdownPreview();
}

const csrfToken = document.querySelector('[name="csrf-token"]').content;

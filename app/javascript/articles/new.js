import 'markdownit';

const textarea = document.getElementById('markdown-input');
const preview = document.getElementById('markdown-preview');
const md = markdownit();

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

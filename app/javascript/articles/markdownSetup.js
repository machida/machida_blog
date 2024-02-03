// markdownSetup.js
export function updateTitlePreview(titleInput, titlePreview) {
  titlePreview.textContent = titleInput.value;
}

export function updateMarkdownPreview(textarea, preview, md) {
  const html = md.render(textarea.value);
  preview.innerHTML = html;
}

export function autoResizeTextarea(textarea) {
  textarea.style.height = 'auto';
  textarea.style.height = (textarea.scrollHeight) + 'px';
}

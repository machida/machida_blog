export function updateTitlePreview(titleInput, titlePreview) {
  titlePreview.textContent = titleInput.value || '無題の記事';
}

export function updateMarkdownPreview(textarea, preview, md) {
  const html = md.render(textarea.value);
  preview.innerHTML = html;
}

export function autoResizeTextarea(textarea) {
  textarea.style.height = 'auto';
  textarea.style.height = `${textarea.scrollHeight}px`;
}

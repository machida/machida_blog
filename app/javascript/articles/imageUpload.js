// imageUpload.js
export function handleDragOver(event) {
  event.stopPropagation();
  event.preventDefault();
  event.dataTransfer.dropEffect = 'copy';
}

export function handleDrop(event, textarea, csrfToken, callback) {
  event.stopPropagation();
  event.preventDefault();

  const files = event.dataTransfer.files;

  if (files.length > 0) {
    const file = files[0];
    if (file.type.match('image.*')) {
      insertTextAtCursor(textarea, 'アップロード中...');
      uploadImage(file, textarea, csrfToken, callback); // コールバックを引数として渡す
    }
  }
}

function uploadImage(file, textarea, csrfToken, callback) {
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
    if (callback) callback(); // コールバックの呼び出し
  })
  .catch(error => console.error('There has been a problem with your fetch operation:', error));
}

export function insertTextAtCursor(textarea, text) {
  const startPos = textarea.selectionStart;
  const endPos = textarea.selectionEnd;
  const beforeText = textarea.value.substring(0, startPos);
  const afterText = textarea.value.substring(endPos);

  textarea.value = beforeText + text + afterText;
  textarea.selectionStart = textarea.selectionEnd = startPos + text.length;
}

export function replaceTextAtPosition(textarea, originalText, newText) {
  const text = textarea.value;
  const position = text.indexOf(originalText);
  if (position !== -1) {
    textarea.value = text.slice(0, position) + newText + text.slice(position + originalText.length);
  }
}

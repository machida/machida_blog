document.addEventListener('keydown', function(event) {
  if ((event.ctrlKey || event.metaKey) && event.key === 's') {
    event.preventDefault();
    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    const isEditPage = window.location.pathname.includes('/edit'); // 編集ページかどうかを判断
    let articleId = null;

    if (isEditPage) {
      articleId = document.getElementById('article_id').value; // 編集の場合はIDを取得
    }

    saveArticleAsDraft(csrfToken, articleId);
  }
});

function saveArticleAsDraft(csrfToken, articleId) {
  const formData = new FormData();
  formData.append('title', document.getElementById('article_title').value);
  formData.append('body', document.getElementById('markdown-input').value);
  formData.append('save_as_draft', true);

  let method;
  let url;

  if (articleId) {
    method = 'PATCH';
    url = `/articles/${articleId}`; // 編集のURL
  } else {
    method = 'POST';
    url = '/articles'; // 新規作成のURL
  }

  fetch(url, {
    method: method,
    headers: {
      'X-CSRF-Token': csrfToken,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(Object.fromEntries(formData))
  })
  .then(response => response.json())
  .then(data => {
    if (!articleId) {
      showToast("記事が下書きとして保存されました。");
      // 新規作成の場合、編集ページにリダイレクト
      window.location.href = `/articles/${data.id}/edit`;
    } else {
      showToast(data.message);
      console.log('Success:', data);
    }
  })
  .catch((error) => {
    console.error('Error:', error);
  })
}

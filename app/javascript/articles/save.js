import { showToast } from 'shared/toast'

document.addEventListener('keydown', function(event) {
  if ((event.ctrlKey || event.metaKey) && event.key === 's') {
    event.preventDefault();
    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    const isEditPage = window.location.pathname.includes('/edit');
    let articleId = null;

    if (isEditPage) {
      articleId = document.getElementById('article_id').value;
    }

    saveArticleAsDraft(csrfToken, articleId);
  }
});

let isSaving = false; // 保存中の状態を追跡するフラグ

function saveArticleAsDraft(csrfToken, articleId) {
  if (isSaving) {
    return; // 既に保存中であれば、処理を中断する
  }
  isSaving = true; // 保存を開始する前にフラグを立てる

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
    isSaving = false; // 保存が完了したらフラグを解除する
    if (!articleId) {
      showToast("記事が下書きとして保存されました。");
      window.location.href = `/articles/${data.id}/edit`;
    } else {
      showToast(data.message);
      console.log('Success:', data);
    }
  })
  .catch((error) => {
    console.error('Error:', error);
    isSaving = false; // エラーが発生した場合もフラグを解除する
  })
}

function showToast(message) {
  // Toast メッセージを表示するための関数
  const toast = document.createElement("div");
  toast.className = "toast";
  toast.textContent = message;

  document.body.appendChild(toast);
  setTimeout(() => {
    toast.classList.add("show");
  }, 100);

  setTimeout(() => {
    toast.classList.remove("show");
    setTimeout(() => {
      document.body.removeChild(toast);
    }, 300);
  }, 3000);
}

console.log('aaaa');
const textarea = document.getElementById('markdown-editor');
const preview = document.getElementById('markdown-editor__preview');
const md = markdownit();

textarea.addEventListener('input', changeTextArea);

function changeTextArea() {
    // Convert the Markdown text to HTML
    const html = md.render(textarea.value);

    // Set the HTML content of the preview element
    preview.innerHTML = html;
}

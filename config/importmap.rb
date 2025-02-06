# Importmap設定ファイル (config/importmap.rb)

# NPMパッケージのピン
pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

# アプリ固有のJavaScriptコントローラーファイル
pin_all_from "app/javascript/controllers", under: "controllers"

# フラッシュメッセージ用コントローラー
pin "flash_controller", to: "controllers/flash_controller.js", preload: true

# マークダウン関連の機能
pin "markdownSetup", to: "/articles/markdownSetup.js"
pin "imageUpload", to: "/articles/imageUpload.js"
pin "edit", to: "/articles/edit.js"
pin "show", to: "/articles/show.js"
pin "save", to: "/articles/save.js"
pin "new", to: "/articles/new.js"

# 共有JavaScriptコンポーネント
pin "shared/toast", to: "shared/toast.js"

# 外部からのJavaScriptライブラリ
pin "postcss-import", to: "https://cdn.jsdelivr.net/npm/postcss-import@16.0.0/+esm"
pin "markdownit", to: "https://cdn.jsdelivr.net/npm/markdown-it@14.0.0/dist/markdown-it.min.js"
pin "markdownitEmoji", to: "https://cdn.jsdelivr.net/npm/markdown-it-emoji@3.0.0/dist/markdown-it-emoji.min.js"
pin "Prism", to: "https://cdn.jsdelivr.net/npm/prismjs@1.29.0/prism.min.js"
pin "prismLineNumbers", to: "https://cdnjs.cloudflare.com/ajax/libs/prism/9000.0.1/plugins/line-numbers/prism-line-numbers.min.js"

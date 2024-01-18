# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "shared/toast"
pin "articles/new"
pin "articles/show"
pin "articles/save"
pin "postcss-import", to: "https://cdn.jsdelivr.net/npm/postcss-import@16.0.0/+esm"
pin "markdownit", to: "https://cdn.jsdelivr.net/npm/markdown-it@14.0.0/dist/markdown-it.min.js"
pin "markdownitEmoji", to: "https://cdn.jsdelivr.net/npm/markdown-it-emoji@3.0.0/dist/markdown-it-emoji.min.js"
pin "Prism", to: "https://cdn.jsdelivr.net/npm/prismjs@1.29.0/prism.min.js"
pin "prismLineNumbers", to: "https://cdnjs.cloudflare.com/ajax/libs/prism/9000.0.1/plugins/line-numbers/prism-line-numbers.min.js"

# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "articles/new"
pin "postcss-import", to: "https://cdn.jsdelivr.net/npm/postcss-import@16.0.0/+esm"
pin "markdownit", to: "https://cdn.jsdelivr.net/npm/markdown-it@14.0.0/dist/markdown-it.min.js"
pin "markdown-it-emoji", to: "https://cdn.jsdelivr.net/npm/markdown-it-emoji@3.0.0/dist/markdown-it-emoji.min.js"

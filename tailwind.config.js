/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    './public/*.html',
    './app/views/**/*',
    './app/components/**/*'
  ],
  theme: {
    extend: {
      colors: {
        'background': '#fff',
        'base': '#fff',
        'main': '#4F46E5',
        'accent': '#FBBF24',
      },
    },
  },
  plugins: [],
}

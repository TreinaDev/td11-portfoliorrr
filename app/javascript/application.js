// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import * as bootstrap from "bootstrap"
import { createApp } from 'vue/dist/vue.esm-bundler.js'
import ProjectsComponent from './components/projects_vue.js'
import "trix"
import "@rails/actiontext"

document.addEventListener('turbo:load', () => {
  createApp(ProjectsComponent).mount('#vue-projects-app')
})

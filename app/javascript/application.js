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

document.addEventListener("DOMContentLoaded", function() {
  const statusRadioButtons = document.querySelectorAll("input[name='post[status]']");
  const scheduledRadioButton = document.querySelector("#post_status_scheduled");
  const publishedAtField = document.querySelector("#post_published_at");

  const togglePublishedAtField = () => {
    if (scheduledRadioButton.checked) {
      publishedAtField.disabled = false;
    } else {
      publishedAtField.disabled = true;
    }
  };

  statusRadioButtons.forEach(button => {
    button.addEventListener('click', togglePublishedAtField);
  });

  togglePublishedAtField();
});

export default {
  data() {
    return {
      projects: [],
    }
  },

  created() {
    fetch('http://localhost:4000/api/v1/projects')
      .then(response => response.json())
      .then(data => projects = data);
  }
}

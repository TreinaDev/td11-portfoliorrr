export default {
  data() {
    return {
      projects: [],
    }
  },

  methods: {
    async getProjects() {
      let response = await fetch('http://localhost:4000/api/v1/projects');
      let projects = await response.json();
      return projects;
    }
  },

  async mounted() {
    this.projects = await this.getProjects();
  }
}

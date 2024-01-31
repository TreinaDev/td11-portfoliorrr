export default {
  data() {
    return {
      projects: [],
      searchText: '',
      selectedFilter: '',
      emptyData: ''
    }
  },
  computed:{
    filteredProjects() {
      const filter = this.selectedFilter
      return this.projects.filter(project => {
        if (filter === 'todos' || filter === '') {
          return (
            project.description.toLowerCase().includes(this.searchText.toLowerCase()) ||
            project.title.toLowerCase().includes(this.searchText.toLowerCase()) ||
            project.category.toLowerCase().includes(this.searchText.toLowerCase())
          )
        } else {
          return project[filter].toLowerCase().includes(this.searchText.toLowerCase());
        }
      })
    }
  },
  methods: {
    setFilter(filter) {
      this.selectedFilter = filter;
    }
  },
  async created() {
    let response = await fetch('/api/v1/projects');
    if (response.ok) {
      let data = await response.json();
      if (data.message) {
        this.emptyData = data.message;
      } else {
        this.projects = data;
      }
    }
  }
}

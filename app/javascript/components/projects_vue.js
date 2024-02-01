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
      const searchType = this.selectedFilter
      return this.projects.filter(project => {
        if (searchType === 'todos' || searchType === '') {
          return (
            project.description.toLowerCase().includes(this.searchText.toLowerCase()) ||
            project.title.toLowerCase().includes(this.searchText.toLowerCase()) ||
            project.category.toLowerCase().includes(this.searchText.toLowerCase())
          )
        } else {
          return project[searchType].toLowerCase().includes(this.searchText.toLowerCase());
        }
      })
    }
  },
  methods: {
    setFilter(selectedSearchType) {
      this.selectedFilter = selectedSearchType;
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

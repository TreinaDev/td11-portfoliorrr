let controller = new AbortController();
let signal = controller.signal;

export default {
  data() {
    return {
      projects: [],
      searchText: '',
      selectedFilter: '',
      showingForm: false,
      currentProjectId: null,
      invitationRequestsProjectsIds: window.invitationRequestsProjectsIds,
      freeUser: window.freeUser,
      errorMsg: false,
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
    showForm(projectId) {
      this.showingForm = true;
      this.currentProjectId = projectId;
    },
    setFilter(selectedSearchType) {
      this.selectedFilter = selectedSearchType;
    },
  },

  beforeUnmount() {
    controller.abort();
  },

  async created() {
    if (!freeUser) {
      try {
        let response = await fetch('/api/v1/projects', { signal });
        if (response.ok) {
          let data = await response.json();
          if (!data.message) {
            this.projects = data;
          }
        } else {
          this.errorMsg = true;
        }
      } catch (error) {
        if (error.name == 'AbortError') {
          console.log('Requisição abortada');
        } else {
          this.errorMsg = true;
        }
      }
    }
  }
}

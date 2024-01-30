export default {
  data() {
    return {
      projects: [],
      categorySearch: '',
      descriptionSearch: '',
      titleSearch: '',
      emptyData: ''
    }
  },
  computed:{
    filteredProjects() {
      return this.projects.filter(project => {
        let matchesTitle = true;
        let matchesCategory = true;
        let matchesDescription = true;
  
        if (this.titleSearch) {
          matchesTitle = project.title.toLowerCase().includes(this.titleSearch.toLowerCase());
        }

        if (this.categorySearch) {
          matchesCategory = project.category.toLowerCase().includes(this.categorySearch.toLowerCase());
        }
  
        if (this.descriptionSearch) {
          matchesDescription = project.description.toLowerCase().includes(this.descriptionSearch.toLowerCase());
        }
  
        return matchesTitle && matchesCategory && matchesDescription;
      });
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

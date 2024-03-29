module ProjectsService
  COLABORA_BASE_URL = Rails.configuration.colabora_api_v1.base_url
  COLABORA_API_V1_PROJECTS_URL = Rails.configuration.colabora_api_v1.projects_url

  class ColaBoraProject
    def self.send
      @response = ColaBoraApiGetProjects.send
      return build_projects if @response.success?

      raise StandardError
    end

    class << self
      private

      def build_projects
        projects = JSON.parse(@response.body, symbolize_names: true)
        projects.map do |project|
          Project.new(id: project[:id],
                      title: project[:title],
                      description: project[:description],
                      category: project[:category])
        end
      end
    end
  end

  class ColaBoraApiGetProjects
    def self.send
      url = "#{COLABORA_BASE_URL}#{COLABORA_API_V1_PROJECTS_URL}"
      Faraday.get(url)
    end
  end
end

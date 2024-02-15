module ProjectsService
  COLABORA_BASE_URL = 'http://localhost:3000'.freeze
  COLABORA_API_V1_PROJECTS_URL = '/api/v1/projects'.freeze

  class ColaBoraProject
    def self.send
      @response = Faraday.get("#{COLABORA_BASE_URL}#{COLABORA_API_V1_PROJECTS_URL}")
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
    rescue Faraday::ConnectionFailed
      raise Exceptions::ColaBoraAPIOffline
    end
  end
end

module Api
  module V1
    class ProjectsController < ApiController
      def index
        response = Faraday.get('http://localhost:3000/api/v1/projects')
        if response.status == 200
          projects = JSON.parse(response.body)
          render status: :ok, json: projects.as_json
        elsif response.status == 500
          errors = JSON.parse(response.body)
          render status: :internal_server_error, json: errors.as_json
        end
      end
    end
  end
end

class InvitationRequestsController < ApplicationController
  def index
    response = Faraday.get('http://localhost:3000/api/v1/projects')
    if response.success?
      projects = JSON.parse(response.body)
      @invitation_requests = current_user.invitation_requests.map do |request|
        project = projects.find { |project| project['id'] == request.project_id }
        {
          message: request.message,
          status: request.status,
          project_title: project['title'],
          project_description: project['description'],
          project_category: project['category']
        }
      end
    end
  end
end

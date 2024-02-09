class InvitationRequestsController < ApplicationController
  def index
    response = Faraday.get('http://localhost:3000/api/v1/projects')
    return unless response.success?

    @projects = JSON.parse(response.body)
    build_invitation_requests
  end

  private

  def build_invitation_requests
    @invitation_requests = current_user.invitation_requests.map do |request|
      project = @projects.find { |proj| proj['id'] == request.project_id }
      {
        message: request.message, status: request.status,
        project_title: project['title'], project_description: project['description'],
        project_category: project['category'], created_at: request.created_at
      }
    end
  end
end

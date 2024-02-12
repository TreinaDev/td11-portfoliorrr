class InvitationRequestInfo
  attr_accessor :id, :status, :created_at, :project_title, :project_description, :project_category, :project_id

  def initialize(invitation_request:, project:)
    @id = invitation_request.id
    @status = invitation_request.status
    @created_at = invitation_request.created_at
    @project_id = project.id
    @project_title = project.title
    @project_description = project.description
    @project_category = project.category
  end
end

class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @invitation_request = current_user.profile.invitation_requests.build
    @invitation_requests = current_user.profile.invitation_requests.pluck(:project_id).to_json
  end

  def create_invitation_request
    invitation_request = current_user.profile.invitation_requests.build(invitation_request_params)

    if invitation_request.save
      flash[:notice] = t('.success')
    else
      flash[:alert] = t('.error')
    end
    redirect_to projects_path
  end

  private

  def invitation_request_params
    invitation_request_params = params.require(:invitation_request).permit(:message)
    invitation_request_params['project_id'] = params['project_id']
    invitation_request_params['email'] = current_user.email
    invitation_request_params['profile_id'] = current_user.profile.id
    invitation_request_params
  end
end

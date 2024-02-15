class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_subscriber, only: :create_invitation_request

  def index
    @invitation_request = current_user.invitation_requests.build
    @invitation_requests = current_user.invitation_requests.pluck(:project_id).to_json
    @invitation_requests_projects_ids = current_user.invitation_requests.pluck(:project_id)
    @projects_url = Rails.configuration.portfoliorrr_api_v1.projects_url
    @free_user = current_user.subscription.inactive?
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

  def authenticate_subscriber
    return if current_user.subscription.active?

    redirect_to root_path, alert: t('alerts.unauthorized')
  end

  def invitation_request_params
    invitation_request_params = params.require(:invitation_request).permit(:message)
    invitation_request_params['project_id'] = params['project_id']
    invitation_request_params
  end
end

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def after_sign_in_path_for(resource)
    if resource.profile.inactive?
      resource.profile.active!
      flash[:notice] = t('.reactivate')
    end

    super
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[full_name citizen_id_number])
  end

  def not_found_error
    flash[:alert] = t('application_errors.not_found')
    redirect_back fallback_location: root_path, status: 303
  end
end

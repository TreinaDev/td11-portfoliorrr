module ProfessionalInfosHelper
  def active_jobs(profile)
    profile.professional_infos.where(current_job: true)
  end
end

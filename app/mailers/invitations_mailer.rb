class InvitationsMailer < ApplicationMailer
  def received_invitation
    profile = Profile.friendly.find(params[:profile_id])
    project_title = params[:project_title]
    mail(subject: t('.subject'), to: profile.user.email)
  end
end

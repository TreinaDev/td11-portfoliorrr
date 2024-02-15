class InvitationsMailer < ApplicationMailer
  def received_invitation
    profile = Profile.find(params[:profile_id])
    project_title = params[:project_title]
    mail(subject: t('.subject'), to: profile.user.email,
         body: t('.body', title: project_title))
  end
end

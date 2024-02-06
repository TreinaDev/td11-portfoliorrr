class InvitationsMailer < ApplicationMailer

  def received_invitation
    profile = Profile.find(params[:profile_id])
    project_title = params[:project_title]
    mail(subject: 'Você recebeu um convite', to: profile.user.email, body: "Você recebeu um convite para participar do projeto #{project_title}.")
  end
end
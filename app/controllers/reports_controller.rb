class ReportsController < ApplicationController
  def new
    set_reportable
    @report = Report.new
    @offences = [
      'Discurso de ódio',
      'Pornografia',
      'Racismo',
      'Spam',
      'Conteúdo pertubador',
      'Abuso/Perseguição'
    ]
  end

  def create
    report_params = params.require(:report).permit(:message, :offence_type, :reportable_id, :reportable_type)
    current_user.profile.reports_submitted.create(report_params)

    redirect_to root_path, notice: t('.success')
  end

  private

  def set_reportable
    reportable_id = params[:reportable]
    @reportable = Post.find_by(reportable_id) if params[:reportable_type] == 'Post'
    @reportable = Profile.find_by(reportable_id) if params[:reportable_type] == 'Profile'
    @reportable = Comment.find_by(reportable_id) if params[:reportable_type] == 'Comment'
  end
end

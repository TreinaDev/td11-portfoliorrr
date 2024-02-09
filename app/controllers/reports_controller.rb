class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reportable_for_new, only: :new
  before_action :set_reportable_for_create, only: :create
  before_action :redirect_unless_published_post
  before_action :redirect_if_self_report, only: :create

  def new
    set_offences
    @report = Report.new
  end

  def create
    @report.save!
    redirect_to root_path, notice: t('.success')
  end

  private

  def set_reportable_for_new
    reportable_id = params[:reportable]
    @reportable = Post.find_by(reportable_id) if params[:reportable_type] == 'Post'
    @reportable = Profile.find_by(reportable_id) if params[:reportable_type] == 'Profile'
    @reportable = Comment.find_by(reportable_id) if params[:reportable_type] == 'Comment'
  end

  def set_reportable_for_create
    report_params = params.require(:report).permit(:message, :offence_type, :reportable_id, :reportable_type)
    @report = current_user.profile.reports_submitted.build(report_params)
    @reportable = @report.reportable
  end

  def redirect_unless_published_post
    redirect_to root_path, alert: t('.not_published_post') unless post_and_published?
  end

  def set_offences
    @offences = [
      'Discurso de ódio',
      'Pornografia',
      'Racismo',
      'Spam',
      'Conteúdo pertubador',
      'Abuso/Perseguição'
    ]
  end

  def post_and_published?
    return true unless @reportable.is_a? Post

    @reportable.published?
  end

  def redirect_if_self_report
    return if @reportable.is_a?(Profile) && @reportable != current_user.profile
    return if @reportable.is_a?(Comment) && @reportable.user != current_user
    return if @reportable.is_a?(Post) && @reportable.user != current_user

    redirect_to root_path, alert: t('.self_report')
  end
end

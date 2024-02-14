class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reportable_for_new, only: :new
  before_action :set_reportable_for_create, only: :create
  before_action :redirect_unless_published_post
  before_action :authorize!, only: %i[index show]
  before_action :redirect_if_self_report, only: :create

  def new
    set_offences
    @report = Report.new
  end

  def create
    @report.save!
    redirect_to root_path, notice: t('.success')
  end

  def index
    return @reports = Report.granted.all if params[:filter] == 'granted'
    return @reports = Report.not_granted.all if params[:filter] == 'not_granted'

    @reports = Report.pending.all
  end

  def show
    @report = Report.find(params[:id])
  end

  private

  def set_reportable_for_new
    reportable_id = params[:reportable]
    @reportable = Post.find(reportable_id) if params[:reportable_type] == 'Post'
    @reportable = Profile.find(reportable_id) if params[:reportable_type] == 'Profile'
    @reportable = Comment.find(reportable_id) if params[:reportable_type] == 'Comment'
    @reportable = Reply.find(reportable_id) if params[:reportable_type] == 'Reply'
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

  def authorize!
    return if current_user.admin?

    redirect_to root_path, alert: t('alerts.unauthorized')
  end

  def redirect_if_self_report
    non_self_report = reportable_classes.any? do |klass|
      @reportable.is_a?(klass) && @reportable.user != current_user
    end

    return if non_self_report

    redirect_to root_path, alert: t('.self_report')
  end

  def reportable_classes
    [Profile, Comment, Post, Reply]
  end
end

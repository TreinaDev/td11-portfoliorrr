class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reportable_for_new, only: :new
  before_action :set_reportable_for_create, only: :create
  before_action :redirect_unless_published_post
  before_action :redirect_if_self_report, only: :create
  before_action :authorize!, only: %i[index show reject remove_content remove_profile]
  before_action :set_report, only: %i[reject show remove_content remove_profile]

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
    return @reports = Report.rejected.all if params[:filter] == 'rejected'

    @reports = Report.pending.all
  end

  def show; end

  def reject
    @report.rejected!
    redirect_to @report, notice: t('.success')
  end

  def remove_content
    @report.reportable.removed!
    @report.granted!
    redirect_to @report, notice: t('.success')
  end

  def remove_profile
    @report.reportable.update removed: true
    @report.reportable.inactive!
    @report.granted!
    redirect_to @report, notice: t('.success')
  end

  private

  def set_reportable_for_new
    reportable_id = params[:reportable]
    @reportable = Post.find(reportable_id) if params[:reportable_type] == 'Post'
    @reportable = Profile.friendly.find(reportable_id) if params[:reportable_type] == 'Profile'
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
      t('reports.hate_speech'),
      t('reports.pornography'),
      t('reports.racism'),
      t('reports.spam'),
      t('reports.disturbin_content'),
      t('reports.harassment')
    ]
  end

  def set_report
    @report = Report.find(params[:id])
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
    reportable_classes = [Profile, Comment, Post, Reply]

    return if reportable_classes.any? do |klass|
      @reportable.is_a?(klass) && @reportable.user != current_user
    end

    redirect_to root_path, alert: t('.self_report')
  end
end

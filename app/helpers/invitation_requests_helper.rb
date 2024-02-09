module InvitationRequestsHelper
  def css_color_class(status)
    class_hash = { processing: 'text-secondary',
                   pending: 'text-info',
                   accepted: 'text-success',
                   refused: 'text-danger',
                   error: 'text-warning',
                   aborted: 'text-danger-emphasis' }
    class_hash[status]
  end

  def invitation_request_filter_options
    InvitationRequest.statuses.keys.map do |status|
      [InvitationRequest.human_attribute_name("status.#{status}"), status]
    end
  end
end

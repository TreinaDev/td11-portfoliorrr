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
end

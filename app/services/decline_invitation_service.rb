class DeclineInvitationService
  def self.send_decline(colabora_invitation_id)
    headers = { 'Content-Type': 'application/json' }
    url = "http://localhost:3000/api/v1/invitations/#{colabora_invitation_id}"

    response = Faraday.patch(url, headers)

    return 'declined' if response.success?

    'cancelled'
  rescue Faraday::ConnectionFailed
    'pending'
  end
end

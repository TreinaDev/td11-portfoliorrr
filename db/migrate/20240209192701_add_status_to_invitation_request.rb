class AddStatusToInvitationRequest < ActiveRecord::Migration[7.1]
  def change
    add_column :invitation_requests, :status, :integer, default: 0
  end
end

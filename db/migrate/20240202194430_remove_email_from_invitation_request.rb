class RemoveEmailFromInvitationRequest < ActiveRecord::Migration[7.1]
  def change
    remove_column :invitation_requests, :email
  end
end

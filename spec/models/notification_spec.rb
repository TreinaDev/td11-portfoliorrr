require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'notificação é criada' do
    it 'envia notificação quando curte um post' do
      author = create(:user)
      user = create(:user)
      post = create(:post, user: author)

      like = create(:like, user:, likeable: post)
      notifications = Notification.all

      expect(notifications.count).to eq 1
      expect(notifications.last.profile).to eq author.profile
      expect(notifications.last.notifiable).to eq like
    end
  end
end

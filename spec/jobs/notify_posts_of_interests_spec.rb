require 'rails_helper'

RSpec.describe PostInterestNotificationJob, type: :job do
  include ActiveJob::TestHelper
  context '.perform' do
    it 'envia notificações aos usuários que comentaram em um post' do
      post_author = create(:user)
      interested_user_one = create(:user)
      interested_user_two = create(:user)

      no_related_user = create(:user)
      commenter_user = create(:user)
      post = create(:post, user: post_author)
      create(:comment, post:, user: interested_user_one)
      create(:comment, post:, user: interested_user_two)

      comment = build(:comment, post:, user: commenter_user)

      PostInterestNotificationJob.perform_now(comment)

      expect(interested_user_one.reload.profile.notifications.count).to eq 1
      expect(interested_user_one.profile.notifications.first.notifiable).to be_a Comment

      expect(interested_user_two.reload.profile.notifications.count).to eq 1
      expect(interested_user_two.profile.notifications.first.notifiable).to be_a Comment

      expect(commenter_user.reload.profile.notifications).to be_empty
      expect(no_related_user.reload.profile.notifications).to be_empty
      expect(post_author.reload.profile.notifications.count).to eq 3
    end

    it 'não envia notificação ao autor do post quando ele tem comentário no próprio post' do
      post_author = create(:user)

      commenter_user = create(:user)
      post = create(:post, user: post_author)

      create(:comment, post:, user: post_author)

      comment = build(:comment, post:, user: commenter_user)

      PostInterestNotificationJob.perform_now(comment)

      expect(post_author.reload.profile.notifications).to be_empty
    end
  end
end

require 'rails_helper'

describe 'Usuário é notificado' do
  context 'sobre posts em que ele comentou' do
    it 'quando alguém comenta nele' do
      post_author = create(:user)
      interested_user = create(:user)

      commenter_user = create(:user)
      post = create(:post, user: post_author, title: 'Meu primeiro post')
      create(:comment, post:, user: commenter_user)

      post_interest_notification_job_spy = spy(PostInterestNotificationJob)
      stub_const('PostInterestNotificationJob', post_interest_notification_job_spy)

      create(:comment, post:, user: interested_user)

      expect(post_interest_notification_job_spy).to have_received(:perform_later)
    end

    it 'e vê a notificação na página de Notificações' do
      post_author = create(:user)
      interested_user = create(:user)

      commenter_user = create(:user, full_name: 'Gabriel')

      post_one = create(:post, user: post_author, title: 'Meu primeiro post')
      post_two = create(:post, user: post_author, title: 'Meu segundo post')

      create(:comment, post: post_one, user: interested_user, created_at: 2.days.ago)
      create(:comment, post: post_two, user: interested_user, created_at: 2.days.ago)

      comment_one = build(:comment, post: post_one, user: commenter_user,
                                    message: 'Meu primerio comentário', created_at: 10.hours.ago)
      comment_two = build(:comment, post: post_two, user: commenter_user,
                                    message: 'Meu segundo comentário', created_at: 10.minutes.ago)

      PostInterestNotificationJob.perform_now(comment_one)
      PostInterestNotificationJob.perform_now(comment_two)

      login_as interested_user
      visit notifications_path

      expect(page).to have_content 'Gabriel comentou no post "Meu segundo post" há 10 minutos'
      expect(page).to have_content 'Gabriel comentou no post "Meu primeiro post" há aproximadamente 10 horas'
      expect(page).to have_link post_one.title, href: post_path(post_one, anchor: "comment-#{comment_one.id}")
      expect(page).to have_link post_two.title, href: post_path(post_two, anchor: "comment-#{comment_two.id}")
    end
  end
end

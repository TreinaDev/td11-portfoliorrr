require 'rails_helper'

RSpec.describe DailyLikesDigestJob, type: :job do
  it 'envia e-mail com resumo diário de curtidas' do
    user = create(:user)
    post_a = create(:post, user:)
    post_b = create(:post, user:)
    comment = create(:comment, user:)
    3.times { create(:like, likeable: post_a) }
    5.times { create(:like, likeable: post_b) }
    2.times { create(:like, likeable: comment) }
    mail = double('mail', deliver: true)
    mailer = double('LikesMailer', notify_new_like: mail)
    allow(LikesMailer).to receive(:with).and_return(mailer)
    allow(mailer).to receive(:notify_like).and_return(mail)

    DailyLikesDigestJob.perform_now(user:)

    expect(mail).to have_received(:deliver).once
  end

  it 'não envia e-mail caso o usuário não tenha nenhuma curtida nas últimas 24 horas' do
    user = create(:user)
    travel_to(2.days.ago) do
      post = create(:post, user:)
      10.times { create(:like, likeable: post) }
    end

    mail = double('mail', deliver: true)
    mailer = double('LikesMailer', notify_new_like: mail)
    allow(LikesMailer).to receive(:with).and_return(mailer)
    allow(mailer).to receive(:notify_like).and_return(mail)

    DailyLikesDigestJob.perform_now(user:)

    expect(mail).not_to have_received(:deliver)
  end

  it 'não envia e-mail caso as curtidas que existam sejam apenas do próprio usuário' do
    user = create(:user)
    post = create(:post, user:)
    comment = create(:comment, post:, user:)
    create(:like, user:, likeable: post)
    create(:like, user:, likeable: comment)

    mail = double('mail', deliver: true)
    mailer = double('LikesMailer', notify_new_like: true)
    allow(LikesMailer).to receive(:with).with(user:).and_return(mailer)
    allow(mailer).to receive(:notify_like).and_return(mail)

    DailyLikesDigestJob.perform_now(user:)

    expect(mail).not_to have_received(:deliver)
  end

  it 'O serviço se reagenda para rodar um próxima vez' do
    user = create(:user)
    ActiveJob::Base.queue_adapter = :test

    expect { DailyLikesDigestJob.perform_now(user:) }.to have_enqueued_job(DailyLikesDigestJob)
                                                     .with(user:).on_queue('default')
  end
end

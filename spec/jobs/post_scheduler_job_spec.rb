require 'rails_helper'

RSpec.describe PostSchedulerJob, type: :job do
  describe '#perform' do
    it 'atualiza status do post' do
      post = create(:post, status: 'scheduled', published_at: Time.zone.tomorrow)

      PostSchedulerJob.perform_now(post)

      expect(Post.last).to be_published
    end
  end
end

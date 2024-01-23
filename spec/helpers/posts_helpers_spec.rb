require 'rails_helper'

RSpec.describe PostHelper, type: :helper do
  describe '#time_since' do
    it 'em segundos' do
      post = create(:post)

      travel_to 30.seconds.from_now do
        expect(helper.time_since(post.created_at)).to eq '29 s'
      end
    end
    it 'em minutos' do
      post = create(:post)

      travel_to 30.minutes.from_now do
        expect(helper.time_since(post.created_at)).to eq '29 m'
      end
    end
    it 'em horas' do
      post = create(:post)

      travel_to 4.hours.from_now do
        expect(helper.time_since(post.created_at)).to eq '3 h'
      end
    end
    it 'em dias' do
      post = create(:post)

      travel_to 10.days.from_now do
        expect(helper.time_since(post.created_at)).to eq '9 d'
      end
    end
  end
end

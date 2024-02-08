require 'rails_helper'

describe 'Usuário denuncia' do
  context 'um post' do
    it 'mas post é um rascunho' do
      user = create(:user)
      post = create(:post, status: :draft)

      login_as user
      post reports_path, params: {
        report: {
          offence_type: 'Discurso de ódio',
          reportable_id: post.id,
          reportable_type: post.class.name,
          profile: user.profile
        }
      }

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq('Essa publicação não está disponível.')
    end

    it 'mas post é um arquivada' do
      user = create(:user)
      post = create(:post, status: :archived)

      login_as user
      post reports_path, params: {
        report: {
          offence_type: 'Discurso de ódio',
          reportable_id: post.id,
          reportable_type: post.class.name,
          profile: user.profile
        }
      }

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Essa publicação não está disponível.'
    end

    it 'mas post está agendado' do
      user = create(:user)
      post = create(:post, status: :scheduled)

      login_as user
      post reports_path, params: {
        report: {
          offence_type: 'Discurso de ódio',
          reportable_id: post.id,
          reportable_type: post.class.name,
          profile: user.profile
        }
      }

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Essa publicação não está disponível.'
    end
  end
end

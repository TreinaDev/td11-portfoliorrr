require 'rails_helper'

describe 'Usuário reporta' do
  context 'um post' do
    it 'com sucesso' do
      post = create(:post)
      user = create(:user)

      login_as user, scope: :user
      visit post_path(post)

      click_on 'Denunciar'
      fill_in 'Mensagem', with: 'Isso é discurso de ódio'
      select 'Discurso de ódio', from: 'Tipo de ofensa'
      click_on 'Denunciar'

      expect(page).to have_content 'Sua denúncia foi registrada'
      expect(Report.last.message).to eq 'Isso é discurso de ódio'
      expect(Report.last.offence_type).to eq 'Discurso de ódio'
      expect(Report.last.reportable).to eq post
      expect(Report.last.status).to eq 'pending'
      expect(Report.last.profile).to eq user.profile
    end
  end
end

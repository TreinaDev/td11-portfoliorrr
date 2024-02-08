require 'rails_helper'

describe 'Usuário denuncia' do
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

    it 'mas post não está publicado' do
      user = create(:user)
      post = create(:post, status: :draft)

      login_as user
      visit new_report_path params: { reportable: post, reportable_type: post.class.name }

      expect(current_path).to eq root_path
      expect(page).to have_content 'Essa publicação não está disponível.'
    end
  end

  context 'um comentário' do
    it 'com sucesso' do
      post = create(:post)
      reported_commend = create(:comment, message: 'Segundo Comentário', post:)
      user = create(:user)

      login_as user, scope: :user
      visit post_path(post)

      within '#comments' do
        click_on 'Denunciar'
      end

      fill_in 'Mensagem', with: 'Isso é discurso de ódio'
      select 'Discurso de ódio', from: 'Tipo de ofensa'
      click_on 'Denunciar'

      expect(page).to have_content 'Sua denúncia foi registrada'
      expect(Report.last.message).to eq 'Isso é discurso de ódio'
      expect(Report.last.offence_type).to eq 'Discurso de ódio'
      expect(Report.last.reportable).to eq reported_commend
      expect(Report.last.status).to eq 'pending'
      expect(Report.last.profile).to eq user.profile
    end
  end

  context 'um perfil' do
    it 'com sucesso' do
      reported_user = create(:user)
      user = create(:user)

      login_as user, scope: :user
      visit profile_path(reported_user.profile)

      click_on 'Denunciar'
      fill_in 'Mensagem', with: 'Isso é discurso de ódio'
      select 'Discurso de ódio', from: 'Tipo de ofensa'
      click_on 'Denunciar'

      expect(page).to have_content 'Sua denúncia foi registrada'
      expect(Report.last.message).to eq 'Isso é discurso de ódio'
      expect(Report.last.offence_type).to eq 'Discurso de ódio'
      expect(Report.last.reportable).to eq reported_user.profile
      expect(Report.last.status).to eq 'pending'
      expect(Report.last.profile).to eq user.profile
    end
  end

  it 'precisa estar logado' do
    post = create(:post)

    visit new_report_path params: { reportable: post, reportable_type: post.class.name }

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end
end

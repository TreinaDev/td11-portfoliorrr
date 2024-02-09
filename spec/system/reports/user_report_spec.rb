require 'rails_helper'

describe 'Usuário denuncia' do
  context 'um post' do
    it 'com sucesso' do
      create(:post)
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

    it 'e não vê botão de report do próprio post' do
      user = create(:user)
      post = create(:post, user:)

      login_as user
      visit post_path(post)

      expect(page).not_to have_content 'Denunciar'
    end

    it 'e não pode denúnciar o próprio comentário' do
      user = create(:user)
      post = create(:comment, user:)

      login_as user
      visit new_report_path params: { reportable: post, reportable_type: 'Comment' }

      fill_in 'Mensagem', with: 'Apenas uma tentativa'
      click_on 'Denunciar'

      expect(page).to have_current_path root_path
      expect(page).to have_content 'Você não pode denúnciar sí mesmo ou o próprio conteúdo.'
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

    it 'e não vê botão de report no próprio comentário' do
      user = create(:user)
      another_user = create(:user)
      post = create(:post, user:)

      create(:comment, user: another_user, post:)
      create(:comment, user:, post:)
      create(:comment, user: another_user, post:)

      login_as user
      visit post_path(post)

      within '#comments' do
        expect(page.all('.report-link-wrapper').size).to eq 2
      end
      expect(page.all('.comment').to_a.second).not_to have_link 'Denunciar'
    end

    it 'e não pode denúnciar o próprio comentário' do
      user = create(:user)
      comment = create(:comment, user:)

      login_as user
      visit new_report_path params: { reportable: comment, reportable_type: 'Comment' }

      fill_in 'Mensagem', with: 'Apenas uma tentativa'
      click_on 'Denunciar'

      expect(page).to have_current_path root_path
      expect(page).to have_content 'Você não pode denúnciar sí mesmo ou o próprio conteúdo.'
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

    it 'e não vê botão de comentar no próprio perfil' do
      user = create(:user)

      login_as user
      visit profile_path(user.profile)

      expect(page).not_to have_link 'Denunciar'
    end

    it 'e não pode denúnciar ele mesmo' do
      user = create(:user)

      login_as user

      visit new_report_path params: { reportable: user.profile, reportable_type: 'Profile' }
      fill_in 'Mensagem', with: 'Apenas uma tentativa'
      click_on 'Denunciar'

      expect(page).to have_current_path root_path
      expect(page).to have_content 'Você não pode denúnciar sí mesmo ou o próprio conteúdo.'
    end
  end

  it 'precisa estar logado' do
    post = create(:post)

    visit new_report_path params: { reportable: post, reportable_type: post.class.name }

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end
end

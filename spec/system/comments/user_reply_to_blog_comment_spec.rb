require 'rails_helper'

describe 'Usuário responde à um comentário' do
  it 'com sucesso' do
    post_owner = create(:user, full_name: 'João')
    commenter = create(:user)
    post = create(:post, user: post_owner)
    create(:comment, user: commenter, post:)

    login_as post_owner
    visit post_path(post)
    within '#comment_1' do
      click_on 'Responder'
      fill_in 'Resposta', with: 'Nem faz sentido isso aí que você comentou'
      click_on 'Enviar Resposta'
      click_on '1 Resposta'
    end

    expect(page).to have_current_path post_path(post)
    expect(page).to have_content('Resposta enviada com sucesso!')
    within '#comment_1' do
      expect(page).to have_content('João (autor)')
      expect(page).to have_content('Nem faz sentido isso aí que você comentou')
      expect(page).to have_content('há menos de um minuto')
    end
  end

  it 'com mensagem de resposta em branco' do
    post_owner = create(:user, full_name: 'João')
    commenter = create(:user)
    post = create(:post, user: post_owner)
    create(:comment, user: commenter, post:)

    login_as post_owner
    visit post_path(post)
    within '#comment_1' do
      click_on 'Responder'
      fill_in 'Resposta', with: ''
      click_on 'Enviar Resposta'
    end

    expect(page).to have_current_path post_path(post)
    expect(page).to have_content('Não foi possível enviar sua resposta')
  end
end

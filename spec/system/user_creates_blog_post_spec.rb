require 'rails_helper'

describe 'Usuário cria uma postagem no blog' do
  it 'apenas quando autenticado' do
    visit new_post_path

    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    user = create(:user, full_name: 'Seiya de Pégaso')

    login_as user
    visit root_path

    within 'nav' do
      click_on 'Criar Nova Publicação'
    end
    save_page

    fill_in 'Título da Publicação', with: 'Olá Mundo!'
    fill_in 'Conteúdo', with: 'Primeira publicação'

    travel_to Time.zone.local(1910, 9, 1, 0, 0, 0) do
      click_on 'Salvar'
    end

    expect(Post.count).to eq 1
    expect(current_path).to eq post_path(Post.first)
    expect(page).to have_content 'Olá Mundo!'
    expect(page).to have_content 'Primeira publicação'
    expect(page).to have_content 'Criado por Seiya de Pégaso'
    expect(page).to have_content 'Publicado em: 01/09/1910'
  end

  it 'apenas se fornecer um título e conteúdo ao post' do
    user = create(:user)

    login_as user
    visit new_post_path(user)

    fill_in 'Título da Publicação', with: ''
    fill_in 'Conteúdo', with: ''

    click_on 'Salvar'

    expect(Post.count).to eq 0
    expect(page).to have_content 'Não foi possível criar sua publicação'
    expect(page).to have_content 'Título da Publicação não pode ficar em branco'
    expect(page).to have_content 'Conteúdo não pode ficar em branco'
  end
end
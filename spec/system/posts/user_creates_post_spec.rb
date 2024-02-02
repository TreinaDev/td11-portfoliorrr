require 'rails_helper'

describe 'Usuário cria uma postagem' do
  it 'apenas quando autenticado' do
    visit new_post_path

    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    user = create(:user, full_name: 'Seiya de Pégaso')

    travel_to 1.day.ago do
      login_as user
      visit root_path
      click_button class: 'dropdown-toggle'

      within 'nav' do
        click_on 'Criar Nova Publicação'
      end

      fill_in 'Título da Publicação', with: 'Olá Mundo!'
      fill_in 'Conteúdo', with: 'Primeira publicação'
      fill_in 'Tags', with: 'tag1, tag2, tag3'

      click_on 'Salvar'
    end

    posts = Post.all
    expect(posts.count).to eq 1
    expect(page).to have_current_path post_path(posts.first)
    expect(page).to have_content 'Olá Mundo!'
    expect(page).to have_content 'Primeira publicação'
    expect(page).to have_content 'Criado por Seiya de Pégaso'
    expect(page).to have_content "Publicado em: #{I18n.l(posts.first.created_at.to_datetime, format: :long)}"
    expect(page).to have_content '#tag1 #tag2 #tag3'
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

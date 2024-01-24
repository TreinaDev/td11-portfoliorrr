require 'rails_helper'

describe 'Usuário cria uma postagem no blog' do
  it 'apenas quando autenticado' do
    visit new_post_path

    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    user = create(:user, full_name: 'Seiya de Pégaso')

    travel_to 1.day.ago do
      login_as user
      visit root_path

      within 'nav' do
        click_on 'Criar Nova Publicação'
      end

      fill_in 'Título da Publicação', with: 'Olá Mundo!'
      fill_in 'Conteúdo', with: 'Primeira publicação'

      click_on 'Salvar'
    end

    posts = Post.all
    expect(posts.count).to eq 1
    expect(current_path).to eq post_path(posts.first)
    expect(page).to have_content 'Olá Mundo!'
    expect(page).to have_content 'Primeira publicação'
    expect(page).to have_content 'Criado por Seiya de Pégaso'
    expect(page).to have_content "Publicado em: #{1.day.ago.strftime('%d/%m/%Y')}"
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

  context 'e vê tempo corrido desde a publicação' do
    it 'menos de um minuto' do
      post = create(:post)

      travel_to 30.seconds.from_now do
        login_as(post.user)
        visit post_path(post)

        expect(page).to have_content 'menos de um minuto'
      end
    end

    it 'alguns minutos' do
      post = create(:post)

      travel_to 2.minutes.from_now do
        login_as(post.user)
        visit post_path(post)

        expect(page).to have_content '2 minutos'
      end
    end

    it 'alguns minutos' do
      post = create(:post)

      travel_to 2.hours.from_now do
        login_as(post.user)
        visit post_path(post)

        expect(page).to have_content '2 horas'
      end
    end
  end
end

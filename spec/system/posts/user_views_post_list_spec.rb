require 'rails_helper'

describe 'Usuário vê a lista de publicações' do
  it 'a partir da home' do
    user = create(:user)
    post = create(:post, user:)
    visitor = create(:user, full_name: 'Andreia' , citizen_id_number: '430.910.060-00', email: 'visitor@email.com')
    
    login_as visitor
    visit root_path
    fill_in 'Buscar Perfil', with: user.full_name
    click_on 'Pesquisar'
    click_on user.full_name

    expect(page).to have_current_path(profile_path(user))
    within 'h2#post-list-title' do
      expect(page).to have_content('Publicações')
    end
    expect(page).to have_content(user.full_name)
    expect(page).to have_link(post.title, href: post_path(post))
  end

  it 'e vê a data de cada publicação' do
    user = create(:user, full_name: 'Gabriel Castro')
    post = create(:post, user:, title: 'Post A', content: 'Primeira postagem')

    login_as user
    visit profile_path(user)

    post_date = post.created_at
    expect(page).to have_content I18n.l(post.created_at, format: :long)
  end

  it 'e vê as postagens ordenadas da mais recente à mais antiga' do
    user = create(:user)

    travel_to(2.days.ago) do
      create(:post, user:, title: 'Post A', content: 'Primeira postagem')
    end
    travel_to(1.day.ago) do
      create(:post, user:, title: 'Texto B', content: 'Segunda postagem')
    end
    create(:post, user:, title: 'Conteúdo C', content: 'Primeira postagem')

    login_as user
    visit profile_path(user)

    expect(page.body.index('Conteúdo C')).to be < page.body.index('Texto B')
    expect(page.body.index('Texto B')).to be < page.body.index('Post A')
  end
end

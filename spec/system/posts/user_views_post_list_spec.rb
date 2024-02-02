require 'rails_helper'

describe 'Usuário vê a lista de publicações' do
  it 'a partir da home' do
    user = create(:user)
    post = create(:post, user:)
    rascunho = create(:post, title: 'Post Rascunho', content: 'Conteúdo do rascunho', user:, status: :draft)
    visitor = create(:user, full_name: 'Andreia', citizen_id_number: '430.910.060-00', email: 'visitor@email.com')

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
    expect(page).not_to have_content(rascunho.title)
  end

  it 'e vê os 300 primeiros caracteres do conteúdo' do
    user = create(:user)
    post = create(:post, content: Faker::Lorem.words(number: 400))

    login_as user
    visit root_path

    expect(page).to have_selector '#post-list', text: post.content.to_plain_text.truncate(300, separator: ' ')
  end

  it 'e vê a data de cada publicação' do
    user = create(:user, full_name: 'Gabriel Castro')
    travel_to(2.days.ago) do
      @post = create(:post, user:, title: 'Post A', content: 'Primeira postagem')
    end

    login_as user
    visit profile_path(user)

    expect(page).to have_content I18n.l(@post.created_at, format: :long)
    expect(page).to have_content ' - 2 dias'
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

  it 'e vê um preview da imagem' do
    post_owner = create(:user)
    visitor = create(:user, full_name: 'Ash Ketchum')

    login_as post_owner
    visit new_post_path(post_owner)
    fill_in 'Título da Publicação', with: 'Como capturar Pókemons?'
    image_path = Rails.root.join('spec/support/assets/images/test_image.png')
    click_button('Attach Files')
    attach_file(image_path, make_visible: true)
    click_on 'Salvar'
    logout

    login_as visitor
    visit root_path

    expect(page).to have_content 'Como capturar Pókemons?'
    expect(page).to have_selector 'img[src*="test_image.png"]'
  end
end

require 'rails_helper'

describe 'Usuário vê a lista de publicações' do
  it 'a partir da home' do
    user = create(:user)
    post = create(:post, user:)
    rascunho = create(:post, title: 'Post Rascunho', content: 'Conteúdo do rascunho', user:, status: :draft)
    visitor = create(:user, full_name: 'Andreia', citizen_id_number: '430.910.060-00', email: 'visitor@email.com')

    login_as visitor
    visit root_path
    fill_in 'Buscar', with: user.full_name
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
                                                          .gsub(/\[[^\]]+\.\w+\]/, '')
  end

  it 'e vê a data de cada publicação' do
    user = create(:user, full_name: 'Gabriel Castro')
    @post = create(:post, user:, title: 'Post A', content: 'Primeira postagem', status: :published,
                          published_at: 2.days.from_now)

    login_as user
    visit profile_path(user)

    expect(page).to have_content 'Há 2 dias'
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

  it 'e vê um preview apenas da imagem' do
    post_owner = create(:user)
    video_path = Rails.root.join('spec/support/assets/videos/test_video.mp4')
    image_path = Rails.root.join('spec/support/assets/images/test_image.png')

    video = ActiveStorage::Blob.create_and_upload!(io: File.open(video_path),
                                                   filename: 'test_video.mp4')
    image = ActiveStorage::Blob.create_and_upload!(io: File.open(image_path),
                                                   filename: 'test_image.png')

    content = %(<action-text-attachment sgid="#{image.attachable_sgid}"></action-text-attachment>
                <action-text-attachment sgid="#{video.attachable_sgid}"></action-text-attachment>)
    post_owner.posts.create(title: 'Como capturar Pókemons?', content:)
    visitor = create(:user, full_name: 'Ash Ketchum')

    login_as visitor
    visit root_path

    expect(page).to have_content 'Como capturar Pókemons?'
    expect(page).to have_selector 'img[src*="test_image.png"]'
    expect(page).not_to have_selector 'video[src*="test_video.mp4"]'
  end

  it 'e vê um preview apenas da primeira imagem anexada' do
    post_owner = create(:user)

    image_path = Rails.root.join('spec/support/assets/images/test_image.png')
    image_two_path = Rails.root.join('spec/support/assets/images/test_image_two.png')

    image = ActiveStorage::Blob.create_and_upload!(io: File.open(image_path),
                                                   filename: 'test_image.png')
    image_two = ActiveStorage::Blob.create_and_upload!(io: File.open(image_two_path),
                                                       filename: 'test_image_two.png')

    content = %(<action-text-attachment sgid="#{image.attachable_sgid}"></action-text-attachment>
                <action-text-attachment sgid="#{image_two.attachable_sgid}"></action-text-attachment>)
    post_owner.posts.create(title: 'Como capturar Pókemons?', content:)
    visitor = create(:user, full_name: 'Ash Ketchum')

    login_as visitor
    visit root_path

    expect(page).to have_content 'Como capturar Pókemons?'
    expect(page).to have_selector 'img[src*="test_image.png"]'
    expect(page).not_to have_selector 'img[src*="test_image_two.png"]'
  end
end

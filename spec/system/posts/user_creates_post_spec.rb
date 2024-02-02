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
      fill_in_rich_text_area 'conteudo', with: 'Primeira <em>publicação</em>'
      fill_in 'Tags', with: 'tag1, tag2, tag3'

      click_on 'Salvar'
    end

    posts = Post.all
    expect(posts.count).to eq 1
    expect(page).to have_current_path post_path(posts.first)
    expect(page).to have_content 'Olá Mundo!'
    expect(page).to have_content 'Primeira'
    expect(page).to have_selector('em', text: 'publicação')
    expect(page).to have_content 'Criado por Seiya de Pégaso'
    expect(page).to have_content I18n.t('posts.views.show.publish_date',
                                        publish_date: I18n.l(posts.first.created_at.to_datetime, format: :long))
    expect(page).to have_content 'tag1 tag2 tag3'
  end

  it 'com sucesso anexando imagem, vídeo e audio' do
    user = create(:user, full_name: 'Seiya de Pégaso')

    login_as user
    visit new_post_path(user)
    fill_in 'Título da Publicação', with: 'Novo post'
    image_path = Rails.root.join('spec/support/assets/images/test_image.png')
    video_path = Rails.root.join('spec/support/assets/videos/test_video.mp4')
    audio_path = Rails.root.join('spec/support/assets/audios/test_audio.mp3')
    pdf_path = Rails.root.join('spec/support/assets/pdfs/test_pdf.pdf')
    click_button('Attach Files')
    attach_file(image_path, make_visible: true)
    click_button('Attach Files')
    attach_file(video_path, make_visible: true)
    click_button('Attach Files')
    attach_file(audio_path, make_visible: true)
    click_button('Attach Files')
    attach_file(pdf_path, make_visible: true)

    click_on 'Salvar'

    expect(Post.count).to eq 1
    expect(page).to have_current_path post_path(Post.first)
    expect(page).to have_selector('img[src*="test_image.png"]')
    expect(page).to have_selector('video[src*="test_video.mp4"]')
    expect(page).to have_selector('audio[src*="test_audio.mp3"]')
    expect(page).to have_selector('embed[src*="test_pdf.pdf"]')
  end

  it 'e anexa arquivo inválido' do
    user = create(:user, full_name: 'Seiya de Pégaso')

    login_as user
    visit new_post_path(user)
    fill_in 'Título da Publicação', with: 'Novo post'
    doc_path = Rails.root.join('spec/support/assets/invalid/test_doc.doc')
    video_path = Rails.root.join('spec/support/assets/invalid/test_video.mov')
    click_button('Attach Files')
    attach_file(doc_path, make_visible: true)
    click_button('Attach Files')
    attach_file(video_path, make_visible: true)

    click_on 'Salvar'

    expect(Post.count).to eq 0
    expect(page).to have_content 'Tipo de arquivo inválido.'
  end

  it 'apenas se fornecer um título e conteúdo ao post' do
    user = create(:user)

    login_as user
    visit new_post_path(user)

    fill_in 'Título da Publicação', with: ''
    fill_in_rich_text_area 'conteudo', with: ''
    click_on 'Salvar'

    expect(Post.count).to eq 0
    expect(page).to have_content 'Não foi possível criar sua publicação'
    expect(page).to have_content 'Título da Publicação não pode ficar em branco'
    expect(page).to have_content 'Conteúdo não pode ficar em branco'
  end
end

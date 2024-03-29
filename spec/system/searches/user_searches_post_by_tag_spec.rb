require 'rails_helper'

describe 'Usuário pesquisa hashtag' do
  it 'ao clicar em uma hashtag específica' do
    post = create(:post, tag_list: %w[tdd rails])
    another_post = create(:post, tag_list: %w[tdd])
    other_post = create(:post, tag_list: %w[rails])

    login_as post.user
    visit post_path(post)

    within '.tags' do
      click_on 'tdd'
    end

    expect(page).to have_content post.title
    expect(page).to have_content another_post.title
    expect(page).not_to have_content other_post.title
    expect(current_path).to eq searches_path
  end

  it 'ao buscar por uma hashtag no campo de busca da home' do
    post = create(:post, tag_list: %w[tdd rails])
    another_post = create(:post, tag_list: %w[tdd])
    other_post = create(:post, tag_list: %w[rails])

    login_as post.user
    visit root_path

    fill_in 'Buscar', with: '#tdd'
    click_on 'Pesquisar'

    expect(page).to have_content post.title
    expect(page).to have_content another_post.title
    expect(page).not_to have_content other_post.title
    expect(page).to have_content '2 Publicações com: #tdd'
    expect(current_path).to eq searches_path
  end

  it 'deve ser uma busca exata' do
    post = create(:post, tag_list: %w[tdd rails])
    another_post = create(:post, tag_list: %w[tdd])
    other_post = create(:post, tag_list: %w[rails])

    login_as post.user
    visit root_path

    fill_in 'Buscar', with: '#td'
    click_on 'Pesquisar'

    expect(page).not_to have_content post.title
    expect(page).not_to have_content another_post.title
    expect(page).not_to have_content other_post.title
    expect(page).to have_content 'Nenhum resultado encontrado com: #td'
    expect(current_path).to eq searches_path
  end
end

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

    expect(current_path).to eq searches_path
    expect(page).to have_content post.title
    expect(page).to have_content another_post.title
    expect(page).not_to have_content other_post.title
  end

  it 'ao buscar por uma hashtag no campo de busca da home' do
    post = create(:post, tag_list: %w[tdd rails])
    another_post = create(:post, tag_list: %w[tdd])
    other_post = create(:post, tag_list: %w[rails])

    login_as post.user
    visit root_path

    fill_in 'Buscar', with: '#tdd'
    click_on 'Pesquisar'

    expect(current_path).to eq searches_path
    expect(page).to have_content post.title
    expect(page).to have_content another_post.title
    expect(page).not_to have_content other_post.title
    expect(page).to have_content '2 Postagens com: #tdd'
  end

  it 'deve ser uma busca exata' do
    post = create(:post, tag_list: %w[tdd rails])
    another_post = create(:post, tag_list: %w[tdd])
    other_post = create(:post, tag_list: %w[rails])

    login_as post.user
    visit root_path

    fill_in 'Buscar', with: '#td'
    click_on 'Pesquisar'

    expect(current_path).to eq searches_path
    expect(page).not_to have_content post.title
    expect(page).not_to have_content another_post.title
    expect(page).not_to have_content other_post.title
    expect(page).to have_content '0 Postagens com: #td'
  end
end

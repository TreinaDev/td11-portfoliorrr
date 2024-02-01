require 'rails_helper'

describe 'Usuário pesquisa hashtag' do
  it 'ao clicar em uma hastag específica' do
    post = create(:post, tag_list: %w[tdd rails])
    another_post = create(:post, tag_list: %w[tdd])
    other_post = create(:post, tag_list: %w[rails])

    login_as post.user
    visit post_path(post)

    within '.tags' do
      click_on 'tdd'
    end

    expect(page).to have_current_path(search_posts_path(tag: 'tdd'))
    expect(page).to have_content post.title
    expect(page).to have_content another_post.title
    expect(page).not_to have_content other_post.title
  end
end

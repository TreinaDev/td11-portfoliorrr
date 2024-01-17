require 'rails_helper'

describe 'Usuário visita uma página de blog' do
  it 'e vê uma lista de links para publicações' do
    user = create(:user, full_name: 'Gabriel Castro')
    post_a = create(:post, user: user, title: 'Post A', content: 'Primeira postagem')
    post_b = create(:post, user: user, title: 'Postagem B', content: 'Segunda postagem')
    post_c = create(:post, user: user, title: 'Texto C', content: 'Último post')

    visit user_posts_path(user)

    expect(page).to have_content 'Blog de Gabriel Castro'
    expect(page).to have_link 'Post A', href: post_path(post_a)
    expect(page).to have_link 'Postagem B', href: post_path(post_b)
    expect(page).to have_link 'Texto C', href: post_path(post_c)
  end

  it 'e vê a data de cada publicação' do
    user = create(:user, full_name: 'Gabriel Castro')
    post_a = create(:post, user: user, title: 'Post A', content: 'Primeira postagem')    
    
    visit user_posts_path(user)

    post_date = post_a.created_at
    
    expect(page).to have_content post_date.to_date.strftime("%d-%m-%y")
  end
end
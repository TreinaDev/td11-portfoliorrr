require 'rails_helper'

describe 'Usuário visita uma página de blog' do
  it 'e vê uma lista de links para publicações' do
    user = create(:user, full_name: 'Gabriel Castro')
    post_a = create(:post, user:, title: 'Post A')
    post_b = create(:post, user:, title: 'Postagem B')
    post_c = create(:post, user:, title: 'Texto C')

    visit user_posts_path(user)

    expect(page).to have_content 'Blog de Gabriel Castro'
    expect(page).to have_link 'Post A', href: post_path(post_a)
    expect(page).to have_link 'Postagem B', href: post_path(post_b)
    expect(page).to have_link 'Texto C', href: post_path(post_c)
  end

  it 'e vê a data de cada publicação' do
    user = create(:user, full_name: 'Gabriel Castro')
    post_a = create(:post, user:, title: 'Post A', content: 'Primeira postagem')

    visit user_posts_path(user)

    post_date = post_a.created_at
    expect(page).to have_content post_date.to_date.strftime('%d-%m-%y')
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

    visit user_posts_path(user)

    expect(page.body.index('Conteúdo C')).to be < page.body.index('Texto B')
    expect(page.body.index('Texto B')).to be < page.body.index('Post A')
  end
end

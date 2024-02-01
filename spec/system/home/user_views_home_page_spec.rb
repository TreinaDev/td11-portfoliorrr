require 'rails_helper'

describe 'Usuário visita a home page' do
  context 'quando logado' do
    it 'e vê somente os posts dos usuários seguidos' do
      follower = create(:user, email: 'usuario@email.com', full_name: 'Usuário', citizen_id_number: '56275577029')
      joao = create(:user, email: 'joao@almeida.com', full_name: 'João Almeida', citizen_id_number: '72647559082')
      andre = create(:user, email: 'akaninja@email.com', full_name: 'André Kanamura', citizen_id_number: '81450892043')
      gabriel = create(:user, email: 'gbriel@campos.com', full_name: 'Gabriel Campos', citizen_id_number: '02010828020')

      first_joao_post = joao.posts.create(title: 'Turma 11', content: 'A melhor turma de todas')
      post_andre = andre.posts.create(title: 'Pull Request', content: 'Façam o Pull Request na main antes...')
      second_joao_post = joao.posts.create(title: 'Warehouses', content: 'Vamos aprender a fazer um app...')
      gabriel.posts.create(title: 'Como fazer uma app Vue', content: 'Não esqueça de usar o app.mount')

      Connection.create!(follower: follower.profile, followed_profile: joao.profile, status: 'active')
      Connection.create!(follower: follower.profile, followed_profile: gabriel.profile, status: 'inactive')
      Connection.create!(follower: follower.profile, followed_profile: andre.profile, status: 'active')

      login_as follower
      visit root_path

      expect(page).not_to have_link('Como fazer uma app Vue')
      expect(page).to have_link('Warehouses', href: post_path(second_joao_post))
      expect(page).to have_link('Pull Request', href: post_path(post_andre))
      expect(page).to have_link('Turma 11', href: post_path(first_joao_post))

      expect(page.body.index('Turma 11')).to be > page.body.index('Pull Request')
      expect(page.body.index('Pull Request')).to be > page.body.index('Warehouses')
    end

    it 'e não existem posts de usuário que ele segue' do
      follower = create(:user, email: 'usuario@email.com', full_name: 'Usuário', citizen_id_number: '56275577029')
      joao = create(:user, email: 'joao@almeida.com', full_name: 'João Almeida', citizen_id_number: '72647559082')
      gabriel = create(:user, email: 'gbriel@campos.com', full_name: 'Gabriel Campos', citizen_id_number: '02010828020')

      displayed_post = []
      displayed_post << gabriel.posts.create(title: 'Como fazer uma app Vue', content: 'Não esqueça de usar o app...')
      gabriel.posts.create(title: 'Como fazer uma app React', content: 'Não esqueça de usar o app...')
      gabriel.posts.create(title: 'Aprenda Ruby on Rails em 1 dia', content: 'Não esqueça...')
      displayed_post << gabriel.posts.create(title: 'Rails new', content: 'Não esqueça de usar o app...')
      displayed_post << gabriel.posts.create(title: 'Boas práticas em ruby', content: 'Não esqueça de usar o app...')

      Connection.create!(follower: follower.profile, followed_profile: joao.profile, status: 'active')

      allow(Post).to receive(:get_sample).and_return(displayed_post)

      login_as follower
      visit root_path

      expect(page).to_not have_content 'Como fazer uma app React'
      expect(page).to_not have_content 'Aprenda Ruby on Rails em 1 dia'
      expect(page).to have_content 'Não existem posts de perfis que você segue'
      expect(page).to have_content 'Veja o que outras pessoas estão publicando:'
      expect(page).to have_content  displayed_post[0].title
      expect(page).to have_content  displayed_post[1].title
      expect(page).to have_content  displayed_post[2].title
    end

    it 'e ainda não segue outros usuários' do
      follower = create(:user, email: 'usuario@email.com', full_name: 'Usuário', citizen_id_number: '56275577029')
      joao = create(:user, email: 'joao@almeida.com', full_name: 'João Almeida', citizen_id_number: '72647559082')
      gabriel = create(:user, email: 'gbriel@campos.com', full_name: 'Gabriel Campos', citizen_id_number: '02010828020')

      joao.posts.create(title: 'Como fazer uma app Vue', content: 'Não esqueça de usar o app...')
      gabriel.posts.create(title: 'Como fazer uma app React', content: 'Não esqueça de usar o app...')
      gabriel.posts.create(title: 'Aprenda Ruby on Rails em 1 dia', content: 'Não esqueça...')

      login_as follower
      visit root_path

      expect(page).to have_content 'Você ainda não segue ninguém'
      expect(page).to have_content 'Siga alguém para personalizar seu feed'
      expect(page).to have_content 'Como fazer uma app Vue'
      expect(page).to have_content 'Como fazer uma app React'
      expect(page).to have_content 'Aprenda Ruby on Rails em 1 dia'
    end

    it 'e vê usuários mais seguidos' do
      first_user = create(:user)
      second_user = create(:user)
      third_user = create(:user)
      fourth_user = create(:user)
      fifth_user = create(:user)
      visitor = create(:user)

      Connection.create!(follower: fourth_user.profile, followed_profile: third_user.profile)
      Connection.create!(follower: fifth_user.profile, followed_profile: third_user.profile)

      Connection.create!(follower: second_user.profile, followed_profile: first_user.profile)
      Connection.create!(follower: third_user.profile, followed_profile: first_user.profile)
      Connection.create!(follower: fourth_user.profile, followed_profile: first_user.profile)
      Connection.create!(follower: fifth_user.profile, followed_profile: first_user.profile)

      Connection.create!(follower: third_user.profile, followed_profile: second_user.profile)
      Connection.create!(follower: fourth_user.profile, followed_profile: second_user.profile)
      Connection.create!(follower: fifth_user.profile, followed_profile: second_user.profile)

      login_as visitor
      visit root_path

      expect(page).to have_content 'Usuários mais seguidos'
      expect(page).to have_content first_user.full_name
      expect(page).to have_content second_user.full_name
      expect(page).to have_content third_user.full_name
      expect(page).not_to have_content fourth_user.full_name
      expect(page).not_to have_content fifth_user.full_name

      expect(page.body.index(first_user.full_name)).to be < page.body.index(second_user.full_name)
      expect(page.body.index(second_user.full_name)).to be < page.body.index(third_user.full_name)
    end
  end

  context 'quando não está logado' do
    it 'e não vê posts' do
      joao = create(:user, email: 'joao@almeida.com', full_name: 'João Almeida', citizen_id_number: '72647559082')
      gabriel = create(:user, email: 'gbriel@campos.com', full_name: 'Gabriel Campos', citizen_id_number: '02010828020')

      joao.posts.create(title: 'Como fazer uma app Vue', content: 'Não esqueça de usar o app...')
      gabriel.posts.create(title: 'Como fazer uma app React', content: 'Não esqueça de usar o app...')

      visit root_path

      expect(page).to have_content 'Faça login ou crie uma conta para descobrir conteúdos relevantes para você.'
      expect(page).not_to have_content 'Como fazer uma app Vue'
      expect(page).not_to have_content 'Como fazer uma app React'
    end

    it 'e não vê usuários mais seguidos' do
      first_user = create(:user)
      second_user = create(:user)
      third_user = create(:user)
      fourth_user = create(:user)
      fifth_user = create(:user)

      Connection.create!(follower: fourth_user.profile, followed_profile: third_user.profile)
      Connection.create!(follower: fifth_user.profile, followed_profile: third_user.profile)

      Connection.create!(follower: second_user.profile, followed_profile: first_user.profile)
      Connection.create!(follower: third_user.profile, followed_profile: first_user.profile)
      Connection.create!(follower: fourth_user.profile, followed_profile: first_user.profile)
      Connection.create!(follower: fifth_user.profile, followed_profile: first_user.profile)

      Connection.create!(follower: third_user.profile, followed_profile: second_user.profile)
      Connection.create!(follower: fourth_user.profile, followed_profile: second_user.profile)
      Connection.create!(follower: fifth_user.profile, followed_profile: second_user.profile)

      visit root_path

      expect(page).not_to have_content 'Usuários mais seguidos'
      expect(page).not_to have_content first_user.full_name
      expect(page).not_to have_content second_user.full_name
      expect(page).not_to have_content third_user.full_name
    end
  end
end

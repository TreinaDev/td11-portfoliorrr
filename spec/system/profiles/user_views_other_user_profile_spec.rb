require 'rails_helper'

describe 'Usuário vê perfil de outro usuário' do
  it 'e vê o número de seguidores' do
    first_follower = create(:user)
    second_follower = create(:user, full_name: 'Gabriel Manika', email: 'emailaleatorio@email.com',
                                    citizen_id_number: '24432047070')
    third_follower = create(:user, full_name: 'Eliseu Ramos', email: 'eliseu@email.com',
                                   citizen_id_number: '60599066059')
    followed = create(:user, full_name: 'Rosemilson Barbosa', email: 'rosemilson@email.com',
                             citizen_id_number: '03971055095')
    Connection.create!(follower: first_follower.profile, followed_profile: followed.profile, status: 'inactive')
    Connection.create!(follower: second_follower.profile, followed_profile: followed.profile,
                       status: 'active')
    Connection.create!(follower: third_follower.profile, followed_profile: followed.profile,
                       status: 'active')

    login_as first_follower
    visit profile_path(followed.profile)

    within '#followers-count' do
      expect(page).to have_link '2 Seguidores', href: profile_connections_path(followed.profile)
    end
  end

  it 'e vê o número de perfis seguidos por ele' do
    first_followed = create(:user)
    second_followed = create(:user, full_name: 'Gabriel Manika', email: 'emailaleatorio@email.com',
                                    citizen_id_number: '24432047070')
    third_followed = create(:user, full_name: 'Eliseu Ramos', email: 'eliseu@email.com',
                                   citizen_id_number: '60599066059')
    follower = create(:user, full_name: 'Rosemilson Barbosa', email: 'rosemilson@email.com',
                             citizen_id_number: '03971055095')

    Connection.create!(follower: follower.profile, followed_profile: first_followed.profile, status: 'inactive')
    Connection.create!(follower: follower.profile, followed_profile: second_followed.profile, status: 'active')
    Connection.create!(follower: follower.profile, followed_profile: third_followed.profile, status: 'active')

    login_as first_followed
    visit profile_path(follower.profile)

    within '#following-count' do
      expect(page).to have_link '2 Seguindo', href: profile_following_path(follower.profile)
    end
  end

  it 'e não consegue ver os links para editar perfil e adicionar informações de outro usuário' do
    user1 = create(:user)
    user2 = create(:user)
    professional_info = create(:professional_info, profile: user2.profile)
    education_info = create(:education_info, profile: user2.profile)

    login_as user1
    visit profile_path(user2.profile)

    expect(page).not_to have_link 'Editar Informações Pessoais', href: edit_user_profile_path
    expect(page).not_to have_link 'Adicionar Experiência Profissional', href: new_user_profile_professional_info_path
    expect(page).not_to have_link 'Editar Experiência Profissional',
                                  href: edit_professional_info_path(professional_info)
    expect(page).not_to have_link 'Adicionar Formação Acadêmica', href: new_user_profile_education_info_path
    expect(page).not_to have_link 'Editar Formação Acadêmica', href: edit_education_info_path(education_info)
    expect(page).not_to have_link 'Adicionar Nova Categoria de Trabalho', href: new_profile_job_category_path
  end
end

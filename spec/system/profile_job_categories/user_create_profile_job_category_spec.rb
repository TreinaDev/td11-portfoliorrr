require 'rails_helper'

describe 'Usuário cadastra categoria de trabalho em seu perfil' do
  it 'com sucesso' do
    user = create(:user, full_name: 'Zelda Hyrule')
    create(:job_category, name: 'Luta com espada')
    create(:job_category, name: 'Magia')
    create(:job_category, name: 'Gestão de Reino Feudal')

    login_as user
    visit root_path
    click_on 'Zelda'
    click_on 'Adicionar nova categoria de trabalho'

    select 'Gestão de Reino Feudal', from: 'Categoria'
    fill_in 'Descrição', with: 'Sou princesa vitalícia de um reino constantemente em guerra com o mal.'
    click_on 'Salvar'

    expect(user.profile.profile_job_categories).not_to be_empty
    expect(page).to have_current_path user_profile_path
    expect(page).to have_content 'Categoria de trabalho adicionada com sucesso!'
    expect(page).to have_content 'Gestão de Reino Feudal'
    expect(page).to have_content 'Sou princesa vitalícia de um reino constantemente em guerra com o mal.'
    expect(page).not_to have_content 'Luta com espada'
    expect(page).not_to have_content 'Magia'
  end

  it 'com sucesso, mesmo deixando a descrição em branco' do
    user = create(:user, full_name: 'Zelda Hyrule')
    create(:job_category, name: 'Magia')

    login_as user
    visit new_profile_job_category_path
    select 'Magia', from: 'Categoria'
    fill_in 'Descrição', with: ''
    click_on 'Salvar'

    expect(user.profile.profile_job_categories).not_to be_empty
    expect(page).to have_content 'Categoria de trabalho adicionada com sucesso!'
    expect(page).to have_content 'Magia'
    expect(page).to have_content 'Não foi adicionada uma descrição para essa categoria.'
  end

  pending 'apenas quando autenticado'
  pending 'e deve escolher uma categoria de trabalho existente'
  pending 'mas é redirecionado se não existem categorias de trabalho disponíveis'
  pending 'apenas se for o dono do perfil sendo alterado'
  pending 'usuário é alertado na tela de formulário que não é possível editar os dados'
  # pending '[request] tenta cadastrar uma categoria que não existe'
end

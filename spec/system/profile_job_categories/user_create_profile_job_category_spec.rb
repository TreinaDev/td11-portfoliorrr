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

    expect(ProfileJobCategory.all).not_to be_empty
    expect(page).to have_current_path profile_path(user.profile)
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

    expect(ProfileJobCategory.all).not_to be_empty
    expect(page).to have_content 'Categoria de trabalho adicionada com sucesso!'
    expect(page).to have_content 'Magia'
    expect(page).to have_content 'Não foi adicionada uma descrição para essa categoria.'
  end

  it 'apenas quando autenticado' do
    visit new_profile_job_category_path

    expect(page).to have_current_path new_user_session_path
  end

  it 'e deve escolher uma categoria de trabalho existente' do
    user = create(:user)
    create(:job_category, name: 'Desenvolvimento de Jogos')

    login_as user
    visit new_profile_job_category_path
    select 'Selecione uma categoria', from: 'Categoria'
    fill_in 'Descrição', with: 'Preguiça de escolher categoria...'
    click_on 'Salvar'

    expect(ProfileJobCategory.all).to be_empty
    expect(page).to have_content 'Cadastrar Categoria de Trabalho no Perfil'
    expect(page).to have_field 'Descrição', with: 'Preguiça de escolher categoria...'
    expect(page).to have_content 'Não foi possível adicionar a categoria de trabalho.'
    expect(page).to have_content 'Categoria de trabalho é obrigatório(a)'
    expect(page).to have_content 'Categoria de trabalho não pode ficar em branco'
  end

  it 'mas é redirecionado se não existem categorias de trabalho disponíveis' do
    user = create(:user)

    login_as user
    visit new_profile_job_category_path

    expect(page).to have_content 'Essa página não está disponível no momento, entre em contato com o administrador.'
    expect(page).to have_current_path profile_path(user.profile)
  end

  it 'e é alertado no formulário sobre não poder editar ou remover os dados no futuro' do
    user = create(:user)
    create(:job_category)

    login_as user
    visit new_profile_job_category_path

    alert_text = 'Atenção: Os dados cadastrados não poderão ser alterados após salvar. Preencha com cuidado.'
    expect(page).to have_content alert_text
  end

  it 'e vê um link para retornar à página de meu perfil' do
    user = create(:user)
    create(:job_category)

    login_as user
    visit profile_path(user.profile)
    click_on 'Adicionar nova categoria de trabalho'
    click_on 'Voltar'

    expect(page).to have_current_path(profile_path(user.profile))
  end

  it 'mas não pode cadastrar a mesma categoria duas ou mais vezes.' do
    user = create(:user)
    user.profile.profile_job_categories.create(job_category: create(:job_category, name: 'Web Design'))

    login_as user
    visit new_profile_job_category_path
    select 'Web Design', from: 'Categoria'
    click_on 'Salvar'

    expect(page).to have_current_path new_profile_job_category_path
    expect(page).to have_content 'Não foi possível adicionar a categoria de trabalho'
    expect(page).to have_content 'Categoria de trabalho já está em uso'
  end
end

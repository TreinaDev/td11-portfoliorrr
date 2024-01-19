require 'rails_helper'

describe 'Usuário cria categoria de trabalho' do
  it 'com sucesso' do
    admin = create(:user, :admin)

    login_as admin
    post job_categories_path, params: { job_category: { name: 'Web Design' } }

    expect(response).to redirect_to(job_categories_path)
    expect(JobCategory.count).to eq(1)
    expect(JobCategory.last.name).to eq('Web Design')
    expect(flash[:notice]).to eq('Categoria de Trabalho criada com sucesso!')
  end

  it 'e deve estar logado' do
    post job_categories_path, params: { job_category: { name: 'Web Design' } }

    expect(response).to redirect_to(new_user_session_path)
    expect(JobCategory.count).to eq(0)
    expect(flash[:alert]).to eq('Para continuar, faça login ou registre-se.')
  end

  it 'e deve ser administrador' do
    user = create(:user)

    login_as user
    post job_categories_path, params: { job_category: { name: 'Web Design' } }

    expect(response).to redirect_to(root_path)
    expect(JobCategory.count).to eq(0)
    expect(flash[:alert]).to eq('Você não têm permissão para realizar essa ação.')
  end
end

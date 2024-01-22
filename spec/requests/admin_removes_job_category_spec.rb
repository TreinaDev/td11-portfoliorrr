require 'rails_helper'

describe 'Usuário remove categoria de trabalho' do
  it 'com sucesso' do
    admin = create(:user, :admin)
    job_category = create(:job_category)

    login_as admin
    delete job_category_path(job_category)

    expect(response).to redirect_to(job_categories_path)
    expect(flash[:notice]).to eq('Categoria de Trabalho removida com sucesso!')
    expect(JobCategory.count).to eq 0
  end

  it 'e deve estar logado' do
    job_category = create(:job_category)

    delete job_category_path(job_category)

    expect(response).to redirect_to(new_user_session_path)
    expect(flash[:alert]).to eq('Para continuar, faça login ou registre-se.')
    expect(JobCategory.count).to eq 1
  end

  it 'e deve ser admin' do
    user = create(:user)
    job_category = create(:job_category)

    login_as user
    delete job_category_path(job_category)

    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eq('Você não têm permissão para realizar essa ação.')
    expect(JobCategory.count).to eq 1
  end
end

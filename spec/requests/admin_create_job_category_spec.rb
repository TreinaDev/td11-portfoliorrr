require 'rails_helper'

describe 'Usuário cria categoria de trabalho' do
  it 'e deve estar logado' do
    post job_categories_path, params: { job_category: { name: 'Web Design' } }

    expect(response).to redirect_to(new_user_session_path)
  end

  it 'e deve ser administrador' do
    user = create(:user)

    login_as user
    post job_categories_path, params: { job_category: { name: 'Web Design' } }

    expect(response).to redirect_to(root_path)
  end
end

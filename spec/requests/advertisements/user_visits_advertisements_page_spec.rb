require 'rails_helper'

describe 'Usuário visita listagem de anúncios' do
  it 'e não é admin' do
    user = create(:user)

    login_as user
    get advertisements_path

    expect(response).to redirect_to root_path
  end

  it 'e não está autenticado' do
    get advertisements_path

    expect(response).to redirect_to new_user_session_path
  end
end

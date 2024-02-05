require 'rails_helper'

describe 'Usuário busca por hashtag' do
  it 'e precisa estar logado' do
    get searches_path

    expect(response).to redirect_to new_user_session_path
  end
end

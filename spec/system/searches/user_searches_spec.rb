require 'rails_helper'

describe 'Usuário pesquisa' do
  it 'mas campo de pesquisa não pode ficar em branco' do
    user = create(:user)

    login_as user
    visit root_path
    fill_in 'Buscar', with: ''
    click_on 'Pesquisar'

    expect(page).to have_current_path root_path
    expect(page).to have_content 'Você precisa informar um termo para fazer a pesquisa'
  end
end

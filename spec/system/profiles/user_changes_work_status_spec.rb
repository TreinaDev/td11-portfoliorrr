require 'rails_helper'

describe 'Usuário altera o status de disponibilidade de trabalho' do
  it 'de disponível para indisponível' do
    user = create(:user)

    login_as user
    visit profile_path(user.profile)
    click_on 'Não estou disponível para trabalho'

    expect(page).to have_current_path profile_path(user.profile)
    expect(page).to have_content 'Alteração salva com sucesso'
    expect(page).not_to have_button 'Não estou disponível para trabalho'
    expect(page).to have_content 'Indisponível para trabalho'
  end

  it 'de indisponível para disponível' do
    user = create(:user)
    user.profile.unavailable!

    login_as user
    visit profile_path(user.profile)
    click_on 'Estou disponível para trabalho'

    expect(page).to have_current_path profile_path(user.profile)
    expect(page).to have_content 'Alteração salva com sucesso'
    expect(page).not_to have_button 'Estou disponível para trabalho'
    expect(page).to have_content 'Disponível para trabalho'
  end
end

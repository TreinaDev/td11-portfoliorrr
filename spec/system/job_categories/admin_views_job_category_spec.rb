require 'rails_helper'

describe 'Usuário vê categorias de trabalho' do
  it 'a partir da home' do
    admin = create(:user, :admin)
    create(:job_category, name: 'Web Design')
    create(:job_category, name: 'Professor')

    login_as admin
    visit root_path
    click_button class: 'dropdown-toggle'
    click_on 'Categorias de trabalho'

    expect(page).to have_content 'Web Design'
    expect(page).to have_content 'Professor'
  end

  it 'e não vê o link se não for administrador' do
    user = create(:user)

    login_as user
    visit root_path

    expect(page).not_to have_link 'Categorias de trabalho'
  end
end

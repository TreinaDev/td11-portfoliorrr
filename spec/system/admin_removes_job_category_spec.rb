require 'rails_helper'

describe 'Usuário remove categoria de trabalho' do
  it 'com sucesso' do
    admin = create(:user, :admin)
    create(:job_category, name: 'Web Design')

    login_as admin
    visit root_path
    click_on 'Categorias de trabalho'
    click_on 'Remover'

    expect(page).to have_current_path(job_categories_path)
    expect(page).to have_content('Categoria de Trabalho removida com sucesso!')
    expect(page).not_to have_content('Web Design')
    expect(JobCategory.count).to eq 0
  end

  it 'e não remove outras categorias' do
    admin = create(:user, :admin)
    create(:job_category, name: 'Web Design')
    create(:job_category, name: 'Programação')

    login_as admin
    visit job_categories_path
    click_on 'Remover', match: :first

    expect(page).to have_content('Categoria de Trabalho removida com sucesso!')
    expect(page).to have_content('Programação')
    expect(page).not_to have_content('Web Design')
    expect(JobCategory.count).to eq 1
  end
end

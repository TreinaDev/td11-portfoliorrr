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
    expect(page).to have_content('Categoria de trabalho removida com sucesso!')
    expect(page).not_to have_content('Web Design')
    expect(JobCategory.count).to eq 0
  end
end

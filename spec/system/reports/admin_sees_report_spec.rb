require 'rails_helper'

describe 'Admin visualiza denúncia' do
  it 'de um post com sucesso' do
    admin = create(:user, :admin)
    post = create(:post, :published, title: 'Título da publicação')
    create(:report, :for_post)
    report = create(:report, reportable: post, message: 'Essa publicação tem duscurso de ódio')
    create(:report, :for_comment)

    login_as admin
    visit reports_path
    page.all('.see_more').to_a.second.click

    expect(page).to have_current_path report_path(report)
    expect(page).to have_content 'Título da publicação'
    expect(page).to have_content 'Essa publicação tem duscurso de ódio'
    expect(page).to have_content "Criado por #{report.reportable.user.full_name}"
  end

  it 'de um comentário com sucesso' do
    admin = create(:user, :admin)
    report = create(:report, :for_comment)

    login_as admin
    visit reports_path
    click_on 'Ver mais'

    expect(page).to have_current_path report_path(report)
    expect(page).to have_content report.reportable.message
    expect(page).to have_content report.message
  end

  it 'de um perfil com sucesso e vê as últimas 3 publicações' do
    admin = create(:user, :admin)
    user = create(:user, full_name: 'Douglas')
    report = create(:report, :for_profile, message: 'Esse perfil é um bot', reportable: user.profile)
    create(:post, user:, title: 'Perfil mais antigo')
    create(:post, user:, title: 'Publicação principal')
    create(:post, user:, title: 'Mais uma publicação')
    create(:post, user:, status: :draft, title: 'Um rascunho de publicação')
    create(:post, user:, title: 'Publicação mais recente')

    login_as admin
    visit reports_path
    click_on 'Ver mais'

    expect(page).to have_current_path report_path(report)
    expect(page).to have_content 'Douglas'
    expect(page).to have_content 'Publicação mais recente'
    expect(page).to have_content 'Publicação principal'
    expect(page).to have_content 'Mais uma publicação'
    expect(page).not_to have_content 'Perfil mais antigo'
    expect(page).not_to have_content 'Um rascunho de publicação'
    expect(page).to have_content 'Esse perfil é um bot'
  end
end

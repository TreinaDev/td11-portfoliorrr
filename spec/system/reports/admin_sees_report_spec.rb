require 'rails_helper'

describe 'Admin visualiza denúncia' do
  it 'de um post com sucesso' do
    admin = create(:user, :admin)
    report = create(:report, :for_post)

    login_as admin
    visit reports_path
    click_on 'Ver mais'

    expect(page).to have_current_path report_path(report)
    expect(page).to have_content report.reportable.title
    expect(page).to have_content report.message
    expect(page).to have_content "Criado por #{report.reportable.user.full_name}"
  end

  xit 'de um comentário com sucesso' do
    admin = create(:user, :admin)
    report = create(:report, :for_post)

    login_as admin
    visit reports_path
    click_on 'Ver mais'

    expect(page).to have_current_path report_path(report)
    expect(page).to have_content report.reportable.message
    expect(page).to have_content report.message
  end

  it 'de um perfil com sucesso' do
    admin = create(:user, :admin)
    report = create(:report, :for_profile)
    post = create(:post, user: report.reportable.user)
    other_post = create(:post, user: report.reportable.user)
    another_post = create(:post, user: report.reportable.user)
    newest_post = create(:post, user: report.reportable.user)

    login_as admin
    visit reports_path
    click_on 'Ver mais'

    expect(page).to have_current_path report_path(report)
    expect(page).to have_content report.reportable.full_name
    expect(page).to have_content newest_post.title
    expect(page).to have_content other_post.title
    expect(page).to have_content another_post.title
    expect(page).not_to have_content post.title
    expect(page).to have_content report.message
  end
end

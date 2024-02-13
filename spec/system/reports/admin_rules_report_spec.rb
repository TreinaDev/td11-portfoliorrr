require 'rails_helper'

describe 'Admin avalia denúncia' do
  it 'decidindo rejeitar a denúncia' do
    admin = create(:user, :admin)
    create(:report, :for_post)
    create(:report, :for_profile)

    login_as admin
    visit reports_path
    page.all('.see_more').to_a.second.click
    click_on 'Rejeitar denúncia'

    expect(Report.first).to be_pending
    expect(Report.second).to be_rejected
    expect(page).to have_content 'Denúncia rejeitada com sucesso'
  end

  it 'decidindo remover o conteúdo' do
    admin = create(:user, :admin)
    post = create(:post, :published)
    create(:report, reportable: post)
    create(:report, :for_comment)

    login_as admin
    visit reports_path
    page.all('.see_more').to_a.first.click
    click_on 'Remover conteúdo'

    expect(Report.first).to be_granted
    expect(Report.second).to be_pending
    expect(page).to have_content 'Conteúdo removido com sucesso'
  end
end

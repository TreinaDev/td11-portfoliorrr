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

  it 'decidindo remover o post' do
    admin = create(:user, :admin)
    post = create(:post, :published)
    create(:report, reportable: post)
    create(:report, :for_comment)

    login_as admin
    visit reports_path
    page.all('.see_more').to_a.first.click
    accept_prompt do
      click_on 'Remover conteúdo'
    end

    expect(Report.first).to be_granted
    expect(Report.second).to be_pending
    expect(post.reload).to be_removed
    expect(page).to have_content 'Conteúdo removido com sucesso'
  end

  it 'decidindo remover o comentário' do
    admin = create(:user, :admin)
    comment = create(:comment)
    create(:report, :for_post)
    create(:report, reportable: comment)

    login_as admin
    visit reports_path
    page.all('.see_more').to_a.second.click
    accept_prompt do
      click_on 'Remover conteúdo'
    end

    expect(Report.first).to be_pending
    expect(Report.second).to be_granted
    expect(comment.reload).to be_removed
    expect(page).to have_content 'Conteúdo removido com sucesso'
  end

  it 'decidindo remover o perfil' do
    admin = create(:user, :admin)
    user = create(:user)
    create(:report, :for_post)
    create(:report, reportable: user.profile)

    login_as admin
    visit reports_path
    page.all('.see_more').to_a.second.click
    accept_prompt do
      click_on 'Remover perfil'
    end

    expect(page).to have_content 'Perfil removido com sucesso'
    expect(Report.first).to be_pending
    expect(Report.second).to be_granted
    expect(user.reload.profile).to be_inactive
    expect(user.profile.removed).to be true
  end
end

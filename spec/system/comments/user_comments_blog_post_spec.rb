require 'rails_helper'

describe 'Usuário comenta uma publicação' do
  context 'com sucesso' do
    it 'em publicação de outro usuário' do
      post = create(:post)
      commenter = create(:user, full_name: 'Peter Parker')

      login_as commenter
      visit post_path(post)
      fill_in 'Mensagem', with: 'Um comentário legal'
      click_on 'Comentar'

      within '#comments' do
        expect(page).to have_link 'Peter Parker', href: profile_path(commenter.profile)
        expect(page).to have_content 'Um comentário legal'
      end
      expect(post).to be_persisted
    end

    it 'em sua própria publicação, e é destacado como o autor da publicação' do
      post = create(:post)

      login_as post.user
      visit post_path(post)
      fill_in 'Mensagem', with: 'Meu post é fenomenal, 10/10, magnum opus.'
      click_on 'Comentar'

      within '#comments' do
        expect(page).to have_link "#{post.user.full_name} (autor)", href: profile_path(post.user.profile)
        expect(page).to have_content 'Meu post é fenomenal, 10/10, magnum opus.'
      end
      expect(post).to be_persisted
    end
  end

  it 'com mensagem em branco e falha' do
    post = create(:post)

    login_as post.user
    visit post_path(post)
    fill_in 'Mensagem', with: ''
    click_on 'Comentar'

    expect(page).to have_content 'Não foi possível fazer o comentário'
    expect(Comment.count).to eq 0
  end
end

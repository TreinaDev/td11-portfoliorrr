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
        expect(page).to have_content "#{post.user.full_name} (autor)"
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

  context 'e desativa o perfil' do
    it 'então o nome é alterado no comentário' do
      user = create(:user, full_name: 'James')
      comment = create(:comment, user:)
      other_user = create(:user)

      user.profile.inactive!
      login_as other_user
      visit post_path(comment.post)

      within '#comments' do
        expect(page).to have_content 'Perfil Desativado'
        expect(page).not_to have_content 'James'
      end
    end
  end

  context 'e exclui sua conta' do
    it 'então o nome é alterado no comentário' do
      user = create(:user, full_name: 'James')
      comment = create(:comment, user:, message: 'Por que a noite é escura?')
      other_user = create(:user)

      login_as user
      visit profile_settings_path(user.profile)
      accept_prompt do
        click_on 'Excluir Conta'
      end
      login_as other_user
      visit post_path(comment.post)

      within '#comments' do
        expect(page).to have_content 'Conta Excluída'
        expect(page).to have_content 'Comentário Removido'
        expect(page).not_to have_content 'James'
        expect(page).not_to have_content 'Por que a noite é escura?'
      end
    end
  end
end

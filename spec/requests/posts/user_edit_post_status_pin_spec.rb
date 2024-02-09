require 'rails_helper'

describe 'Usuário edita status de postagem para fixado' do
  it 'deve ser dono do post' do
    user = create(:user)
    post = create(:post, user:)
    other_user = create(:user, citizen_id_number: '840.413.720-03', email: 'other_user@email.com')

    login_as(other_user)
    post pin_post_path(post)

    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eq('Você não pode acessar este conteúdo ou realizar esta ação')
    expect(post.reload.pinned?).to eq(false)
  end
end

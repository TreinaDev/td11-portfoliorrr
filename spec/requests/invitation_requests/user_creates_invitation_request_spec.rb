require 'rails_helper'

describe 'Usuário solicita convite para um projeto' do
  it 'com sucesso' do
    user = create(:user, :paid)
    login_as user
    post invitation_request_path, params: {
      'project_id' => 1,
      'invitation_request' => {
        'message' => 'Me convida'
      }
    }
    user_requests = user.profile.invitation_requests

    expect(user_requests.reload.count).to eq 1
    expect(user_requests.last.message).to eq 'Me convida'
  end

  it 'e falha se já solicitou convite para o mesmo projeto' do
    user = create(:user, :paid)
    create(:invitation_request, profile: user.profile)
    login_as user

    post invitation_request_path, params: {
      'project_id' => 1,
      'invitation_request' => {
        'message' => 'Me convida denovo'
      }
    }

    expect(flash[:alert]).to eq 'Não foi possível enviar solicitação'
    expect(user.profile.invitation_requests.last).not_to be_valid
  end

  it 'e deve estar logado' do
    post invitation_request_path, params: {
      'project_id' => 1,
      'invitation_request' => {
        'message' => 'Me convida'
      }
    }
    expect(response).to redirect_to(new_user_session_path)
    expect(flash[:alert]).to eq('Para continuar, faça login ou registre-se.')
  end

  it 'e deve possuir conta premium' do
    user = create(:user, :free)
    login_as user

    post invitation_request_path, params: {
      'project_id' => 1,
      'invitation_request' => {
        'message' => 'Me convida'
      }
    }

    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eq('Você não têm permissão para realizar essa ação.')
  end
end

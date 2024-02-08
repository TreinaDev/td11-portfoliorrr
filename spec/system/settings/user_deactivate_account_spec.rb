require 'rails_helper'

describe 'Usuário desativa sua conta' do
	it 'com sucesso' do
		user = create(:user)

		login_as user
		visit root_path
		click_button class: 'dropdown-toggle'
		click_on 'Configurações'
		accept_prompt do
			click_on 'Desativar Conta'
		end

		expect(page).to have_current_path root_path
		expect(page).to have_content 'Conta desativada com sucesso'
	end
end

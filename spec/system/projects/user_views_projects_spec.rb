require 'rails_helper'

describe 'Usuário visita página de projetos' do
  context 'quando logado' do
    it 'e vê lista de projetos' do
      user = create(:user)

      login_as user

      visit root_path

      click_on 'Projetos'

      expect(page).to have_current_path projects_path
      expect(page).to have_content('Lista de Projetos', wait: 0.5)

      expect(page).to have_content 'Título: Padrão 1'
      expect(page).to have_content 'Descrição: Descrição de um projeto padrão para testes 1.'
      expect(page).to have_content 'Categoria: Categoria de projeto'
      expect(page).to have_content 'Líder de Ginásio'
      expect(page).to have_content 'Me tornar líder do estádio de pedra.'
      expect(page).to have_content 'Auto Ajuda'

      expect(page).to have_content 'Pokedex'
      expect(page).to have_content 'Fazer uma listagem de todos os pokemons.'
      expect(page).to have_content 'Tecnologia'
    end
  end
end

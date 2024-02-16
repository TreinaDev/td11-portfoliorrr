require 'rails_helper'

describe 'Usuário visualiza anúncios na home page' do
  context 'com assinatura free' do
    it 'a cada 5 posts' do
      user = create(:user, :free)
      admin = create(:user, role: 'admin')
      ad1 = create(:advertisement, user: admin, title: 'Cursos de Software', link: 'https://campuscode.com.br')
      ad2 = create(:advertisement, user: admin, title: 'Venha ser Dev', link: 'https://dev.com.br')

      10.times { create(:post) }
      allow(Post).to receive(:get_sample).and_return(Post.all)
      allow(Advertisement).to receive(:displayed).and_return([ad1], [ad2])

      login_as user
      visit root_path

      within "#advertisement_#{ad1.id}" do
        expect(page).to have_button 'Cursos de Software'
      end
      within "#advertisement_#{ad2.id}" do
        expect(page).to have_button 'Venha ser Dev'
      end

      expect(page).to have_selector '.advertisement', count: 2
      expect(page.body.index(Post.find(5).title)).to be < page.body.index('Cursos de Software')
      expect(page.body.index(Post.find(6).title)).to be > page.body.index('Cursos de Software')
      expect(page.body.index(Post.find(10).title)).to be < page.body.index('Venha ser Dev')
    end

    it 'e clica em um anúncio' do
      user = create(:user, :free)
      admin = create(:user, role: 'admin')
      ad = create(:advertisement, user: admin, title: 'Cursos de Software',
                  link: 'https://www.campuscode.com.br', view_count: 0)
      ad.image.attach(io: File.open('spec/support/assets/images/test_image.png'),
                      filename: 'test_image.png', content_type: 'image/png')
      ad.save

      5.times { create(:post) }
      allow(Post).to receive(:get_sample).and_return(Post.all)
      login_as user
      visit root_path

      within "#advertisement_#{ad.id}" do
        click_button id: 'to-ad'
      end

      expect(ad.reload.view_count).to eq 1
      expect(page).to have_current_path ad.link
    end
  end

  context 'com assinatura premium' do
    it 'não visualiza anúncios' do
      user = create(:user, :paid)
      admin = create(:user, role: 'admin')
      ad = create(:advertisement, user: admin, title: 'Cursos de Software',
                  link: 'https://www.campuscode.com.br', view_count: 0)
      ad.image.attach(io: File.open('spec/support/assets/images/test_image.png'),
                      filename: 'test_image.png', content_type: 'image/png')
      ad.save

      5.times { create(:post) }
      allow(Post).to receive(:get_sample).and_return(Post.all)
      login_as user
      visit root_path

      expect(page).not_to have_css "#advertisement_#{ad.id}"
      expect(page).not_to have_content 'Cursos de Software'
      expect(page).not_to have_link 'https://www.campuscode.com.br'
    end
  end
end

# Adiciona usuários
joao = User.create(email: 'joao@almeida.com', password: '123456', full_name: 'João CampusCode Almeida', citizen_id_number: '72647559082', role: 'admin')
andre = User.create(email: 'akaninja@email.com', password: 'usemogit', full_name: 'André Kanamura', citizen_id_number: '81450892043')
gabriel = User.create(email: 'gabriel@campos.com', password: 'oigaleraaa', full_name: 'Gabriel Campos', citizen_id_number: '02010828020')

# Adiciona publicações
image_post_one = ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join('app', 'assets', 'images', 'seeds', 'turma_11.jpeg')), filename: 'turma_11.jpeg')
html_post_one = %(<action-text-attachment sgid="#{image_post_one.attachable_sgid}"></action-text-attachment>)
post_joao_1 = joao.posts.create(title: 'Turma 11', content: "A melhor turma de todas<br> #{html_post_one}")

post_joao_2 = joao.posts.create(title: 'Warehouses', content: "Vamos aprender a fazer um app de gestão de galpões<br>")

post_joao_3 = joao.posts.create(title: 'Rubocop: devo usar?', content: "No começo, tem que aprender na marra.<br>")

image_post_two = ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join('app', 'assets', 'images', 'seeds', 'git_github.jpg')), filename: 'git_github.jpg')
html_post_two = %(<action-text-attachment sgid="#{image_post_two.attachable_sgid}"></action-text-attachment>)
post_andre_1 = andre.posts.create(title: 'Pull Request', content: "Façam o Pull Request na main antes de usar o código nas branches dos outros<br> #{html_post_two}")

post_andre_2 = andre.posts.create(title: 'Desafios Exclusivos', content: "Eu fiz o batalha naval mesmo para desafiar a galera<br>")

post_andre_3 = andre.posts.create(title: 'SOLID', content: "Hoje, vamos falar sobre boas prática de desenvolvimento de código<br>")

image_post_three = ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join('app', 'assets', 'images', 'seeds', 'vue_js.jpg')), filename: 'vue_js.jpg')
html_post_three = %(<action-text-attachment sgid="#{image_post_three.attachable_sgid}"></action-text-attachment>)
post_gabriel_1 = gabriel.posts.create(title: 'Como fazer uma app Vue', content: "Não esqueça de usar o app.mount<br> #{html_post_three}")

post_gabriel_2 = gabriel.posts.create(title: 'Boas práticas em Zoom', content: "Hoje vamos falar sobre breakout rooms!<br>")

post_gabriel_3 = gabriel.posts.create(title: 'Robô Saltitante: como resolver?', content: "Vamos falar sobre a tarefa mais complexa do Code Saga!<br>")

joao.profile.update(cover_letter: 'Sou profissional organizado, esforçado e apaixonado pelo que faço', work_status: 'unavailable')
andre.profile.update(cover_letter: 'Sou profissional organizado, esforçado e apaixonado pelo que faço', work_status: 'open_to_work')
gabriel.profile.update(cover_letter: 'Sou profissional organizado, esforçado e apaixonado pelo que faço', work_status: 'open_to_work')

# Adiciona informações pessoais aos perfis
joao.profile.personal_info.update(city: 'São Paulo', state: 'SP')
andre.profile.personal_info.update(city: 'Cuiabá', state: 'MT')
gabriel.profile.personal_info.update(city: 'Salvador', state: 'BA')

# Adiciona informações profissionais aos perfis
joao.profile.professional_infos.create(company: 'Campus Code', position: 'Dev', current_job: false, visibility: true,
                                       description: 'Muito código', start_date: '2022-12-12', end_date: '2023-12-12')
andre.profile.professional_infos.create(company: 'Rebase', position: 'Dev', current_job: false, visibility: true,
                                        description: 'Muito muito código', start_date: '2022-12-12', end_date: '2023-12-12')
gabriel.profile.professional_infos.create(company: 'Vindi', position: 'Dev', current_job: true, visibility: true,
                                          description: 'A lot of code', start_date: '2022-12-12')

# Adiciona informações acadêmicas aos perfis
joao.profile.education_infos.create(institution: 'Senai', course: 'Web dev full stack', visibility: true,
                                    start_date: '2022-12-12', end_date: '2023-12-12')
andre.profile.education_infos.create(institution: 'Fiap', course: 'Sistemas de Informação', visibility: true,
                                     start_date: '2022-12-12', end_date: '2023-12-12')
gabriel.profile.education_infos.create(institution: 'Fatec', course: 'Análise e Desenvolvimento de Sistemas',
                                       visibility: true, start_date: '2022-12-12', end_date: '2023-12-12')

joao.profile.education_infos.create(institution: 'Senai', course: 'Web dev full stack', visibility: true,
                                    start_date: '2022-12-12', end_date: '2023-12-12')
andre.profile.education_infos.create(institution: 'Fiap', course: 'Sistemas de Informação', visibility: true,
                                    start_date: '2022-12-12', end_date: '2023-12-12')
gabriel.profile.education_infos.create(institution: 'Fatec', course: 'Análise e Desenvolvimento de Sistemas',
                                      visibility: true, start_date: '2022-12-12', end_date: '2023-12-12')

# Adiciona categorias de trabalho
JobCategory.create(name: 'Web Design')
JobCategory.create(name: 'Programador Full Stack')
JobCategory.create(name: 'Ruby on Rails')

# Adiciona categorias de trabalho aos perfis da aplicação
ProfileJobCategory.create(profile: gabriel.profile, job_category: JobCategory.first, description: 'Eu amo Ruby')
ProfileJobCategory.create(profile: andre.profile, job_category: JobCategory.first, description: 'Eu uso Figma.')
ProfileJobCategory.create(profile: andre.profile, job_category: JobCategory.second, description: 'Uso Bootstrap.')
ProfileJobCategory.create(profile: joao.profile, job_category: JobCategory.first, description: 'Eu uso o Paint.')
ProfileJobCategory.create(profile: joao.profile, job_category: JobCategory.second, description: 'Prefiro Tailwind.')
ProfileJobCategory.create(profile: joao.profile, job_category: JobCategory.last, description: 'Eu amo Rails.')

# Adiciona conexões de seguidores aos perfis
Connection.create(follower: joao.profile, followed_profile: andre.profile)
Connection.create(follower: gabriel.profile, followed_profile: andre.profile)
Connection.create(follower: andre.profile, followed_profile: joao.profile)
Connection.create(follower: gabriel.profile, followed_profile: joao.profile)
Connection.create(follower: andre.profile, followed_profile: gabriel.profile)
Connection.create(follower: joao.profile, followed_profile: gabriel.profile)

# Adiciona comentários às publicações
post_joao_1.comments.create(user: joao, message: 'Meu texto é muito bom.')
post_joao_1.comments.create(user: andre, message: 'Interessante.')
post_joao_1.comments.create(user: gabriel, message: 'Que legal!')
post_joao_2.comments.create(user: joao, message: 'Meu texto é muito bom.')
post_joao_2.comments.create(user: andre, message: 'Interessante.')
post_joao_2.comments.create(user: gabriel, message: 'Que legal!')
post_joao_3.comments.create(user: joao, message: 'Meu texto é muito bom.')
post_joao_3.comments.create(user: andre, message: 'Interessante.')
post_joao_3.comments.create(user: gabriel, message: 'Que legal!')

post_andre_1.comments.create(user: andre, message: 'Meu texto é muito bom.')
post_andre_1.comments.create(user: joao, message: 'Interessante.')
post_andre_1.comments.create(user: gabriel, message: 'Que legal!')
post_andre_2.comments.create(user: andre, message: 'Meu texto é muito bom.')
post_andre_2.comments.create(user: joao, message: 'Interessante.')
post_andre_2.comments.create(user: gabriel, message: 'Que legal!')
post_andre_3.comments.create(user: andre, message: 'Meu texto é muito bom.')
post_andre_3.comments.create(user: joao, message: 'Interessante.')
post_andre_3.comments.create(user: gabriel, message: 'Que legal!')

post_gabriel_1.comments.create(user: gabriel, message: 'Meu texto é muito bom.')
post_gabriel_1.comments.create(user: joao, message: 'Interessante.')
post_gabriel_1.comments.create(user: andre, message: 'Que legal!')
post_gabriel_2.comments.create(user: gabriel, message: 'Meu texto é muito bom.')
post_gabriel_2.comments.create(user: joao, message: 'Interessante.')
post_gabriel_2.comments.create(user: andre, message: 'Que legal!')
post_gabriel_3.comments.create(user: gabriel, message: 'Meu texto é muito bom.')
post_gabriel_3.comments.create(user: joao, message: 'Interessante.')
post_gabriel_3.comments.create(user: andre, message: 'Que legal!')


# Adiciona convites
FactoryBot.create(:invitation, profile: joao.profile, status: 'accepted', project_title: 'Projeto Gotta cath`em all', project_description: 'Capturar todos os Pokémons', project_category: 'Collection', expiration_date: 1.day.from_now)

FactoryBot.create(:invitation, profile: joao.profile, status: 'pending', project_title: 'Projeto King of Games', project_description: 'Se tornar o melhor duelista de todos os tempos', project_category: 'Achievments', expiration_date: 1.week.from_now)

invitation = FactoryBot.build(:invitation, profile: joao.profile, status: 'declined', project_title: 'Projeto Code Saga', project_description: 'Aprender a programar', project_category: 'Education', expiration_date: 1.week.ago)
invitation.save(validate: false)



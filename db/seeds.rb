joao = User.create(email: 'joao@almeida.com', password: '123456', full_name: 'João CampusCode Almeida', citizen_id_number: '72647559082', role: 'admin')
andre = User.create(email: 'akaninja@email.com', password: 'usemogit', full_name: 'André Kanamura', citizen_id_number: '81450892043')
gabriel = User.create(email: 'gabriel@campos.com', password: 'oigaleraaa', full_name: 'Gabriel Campos', citizen_id_number: '02010828020')

post_joao_1 = joao.posts.create(title: 'Turma 11', content: 'A melhor turma de todas')
post_joao_2 = joao.posts.create(title: 'Warehouses', content: 'Vamos aprender a fazer um app de gestão de galpões')
post_joao_3 = joao.posts.create(title: 'Rubocop: devo usar?', content: 'No começo, tem que aprender na marra.')
post_andre_1 = andre.posts.create(title: 'Pull Request', content: 'Façam o Pull Request na main antes de usar o código nas branches dos outros')
post_andre_2 = andre.posts.create(title: 'Desafios Exclusivos', content: 'Eu fiz o batalha naval mesmo para desafiar a galera')
post_andre_3 = andre.posts.create(title: 'SOLID', content: 'Hoje, vamos falar sobre boas prática de desenvolvimento de código')
post_gabriel_1 = gabriel.posts.create(title: 'Como fazer uma app Vue', content: 'Não esqueça de usar o app.mount')
post_gabriel_2 = gabriel.posts.create(title: 'Boas práticas em Zoom', content: 'Hoje vamos falar sobre breakout rooms!')
post_gabriel_3 = gabriel.posts.create(title: 'Robô Saltitante: como resolver?', content: 'Vamos falar sobre a tarefa mais complexa do Code Saga!')

JobCategory.create(name: 'Web Design')
JobCategory.create(name: 'Programador Full Stack')
JobCategory.create(name: 'Ruby on Rails')

ProfileJobCategory.create(profile: User.last.profile, job_category: JobCategory.last)

Follower.create(follower: joao.profile, followed_profile: andre.profile)
Follower.create(follower: gabriel.profile, followed_profile: andre.profile)

Follower.create(follower: andre.profile, followed_profile: joao.profile)
Follower.create(follower: gabriel.profile, followed_profile: joao.profile)

Follower.create(follower: andre.profile, followed_profile: gabriel.profile)
Follower.create(follower: joao.profile, followed_profile: gabriel.profile)

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create(email: 'joao@almeida.com', password: '123456', full_name: 'João CampusCode Almeida', citizen_id_number: '00752496263')
User.create(email: 'akaninja@email.com', password: 'usemogit', full_name: 'André Kanamura', citizen_id_number: '00232728305')
User.create(email: 'gabriel@campos.com', password: 'oigaleraaa', full_name: 'Gabriel Campos', citizen_id_number: '02742567895')

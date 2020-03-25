# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(
  email: "admin@email.com",
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name, password: "12345",
  password_confirmation: "12345")

5.times do
  User.create(
    email: Faker::Internet.email,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name, password: "12345",
    password_confirmation: "12345")
end

book_1 = Book.create(name: "Clean Code")
book_2 = Book.create(name: "Clean Coder")
book_3 = Book.create(name: "All Code")
book_4 = Book.create(name: "All Coder")
book_5 = Book.create(name: "Why Code")
book_6 = Book.create(name: "Why Coder")
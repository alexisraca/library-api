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

Book.create(name: "Clean Code")
Book.create(name: "Clean Coder")
Book.create(name: "All Code")
Book.create(name: "All Coder")
Book.create(name: "Why Code")
Book.create(name: "Why Coder")

html_format = ContentFormat.create(name: "HTML")

Book.all.each do |book|
  5.times do
    page = book.pages.create
    page.contents.create(body: "<html></html>", content_format: html_format)
  end
end

